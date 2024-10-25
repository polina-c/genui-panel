import * as fs from "fs";
import * as os from "os";
import * as path from "path";
import * as vs from "vscode";
import { window, workspace } from "vscode";
import { CommandSource, cpuProfilerPage, dartVMPath, devToolsHomePage, devToolsToolLegacyPath, devToolsToolPath, isDartCodeTestRun, skipAction, tryAgainAction, twentySecondsInMs, widgetInspectorPage } from "../shared/constants";
import { LogCategory, VmService } from "../shared/enums";
import { DartWorkspaceContext, DevToolsPage, Logger } from "../shared/interfaces";
import { CategoryLogger } from "../shared/logging";
import { getPubExecutionInfo } from "../shared/processes";
import { UnknownNotification } from "../shared/services/interfaces";
import { StdIOService } from "../shared/services/stdio_service";
import { disposeAll, usingCustomScript } from "../shared/utils";
import { getRandomInt } from "../shared/utils/fs";
import { waitFor } from "../shared/utils/promises";
import { ANALYSIS_FILTERS } from "../shared/vscode/constants";
import { getLanguageStatusItem } from "../shared/vscode/status_bar";
import { envUtils, getAllProjectFolders, isRunningLocally } from "../shared/vscode/utils";
import { Context } from "../shared/vscode/workspace";

const devtoolsPackageID = "devtools";
const devtoolsPackageName = "Dart DevTools";

// This starts off undefined, which means we'll read from config.devToolsPort and fall back to undefined (use default).
// Once we get a port we'll update this variable so that if we restart (eg. a silent extension restart due to
// SDK change or similar) we will try to use the same port, so if the user has browser windows open they're
// still valid.
let portToBind: number | undefined;

/// Handles launching DevTools in the browser and managing the underlying service.
export class DevToolsManager implements vs.Disposable {
    private readonly disposables: vs.Disposable[] = [];
    private readonly statusBarItem = getLanguageStatusItem("dart.devTools", ANALYSIS_FILTERS);
    private service?: any;

    /// Resolves to the DevTools URL. This is created immediately when a new process is being spawned so that
    /// concurrent launches can wait on the same promise.
    public devtoolsUrl: Thenable<string> | undefined;

    private isShuttingDown = false;

    constructor(
        private readonly logger: Logger,
        private readonly context: Context,
    ) {
        this.statusBarItem.name = "Dart/Flutter DevTools";
        this.statusBarItem.text = "Dart DevTools";
        this.setNotStartedStatusBar();

        void this.handleEagerActivationAndStartup(context.workspaceContext);
    }

    private setNotStartedStatusBar() {
        this.statusBarItem.command = {
            arguments: [{ commandSource: CommandSource.languageStatus }],
            command: "dart.openDevTools",
            title: "start & launch",
            tooltip: "Start and Launch DevTools",
        };
    }

    private setStartedStatusBar(url: string) {
        this.statusBarItem.command = {
            arguments: [{ commandSource: CommandSource.languageStatus }],
            command: "dart.openDevTools",
            title: "launch",
            tooltip: `DevTools is running at ${url}`,
        };
    }

    private async handleEagerActivationAndStartup(workspaceContext: DartWorkspaceContext) {
        if (workspaceContext.config?.startDevToolsServerEagerly) {
            try {
                await this.start(true);
            } catch (e) {
                this.logger.error("Failed to background start DevTools");
                this.logger.error(e);
                void vs.window.showErrorMessage(`Failed to start DevTools: ${e}`);
            }
        }
    }

    public isPageAvailable(hasSession: boolean, page: DevToolsPage) {

        return true;
    }

    private routeIdForPage(page: DevToolsPage | undefined | null): string | undefined {
        if (!page)
            return undefined;

        if (page.routeId)
            return page.routeId(undefined);

        return page.id;
    }

    public async urlFor(page: string): Promise<string | undefined> {
        const base = await this.devtoolsUrl;
        if (!base) return base;

        const queryString = this.buildQueryString(this.getDefaultQueryParams());
        const separator = base.endsWith("/") ? "" : "/";
        return `${base}${separator}${page}?${queryString}`;
    }

    public async start(silent = false): Promise<string | undefined> {

        if (!this.devtoolsUrl) {
            this.setNotStartedStatusBar();


            // Ignore silent flag if we're using a custom DevTools, because it could
            // take much longer to start and won't be obvious why launching isn't working.
            const isCustomDevTools = false;
            const startingTitle = isCustomDevTools ? "Starting Custom Dart DevTools…" : "Starting Dart DevTools…";
            if (silent && !isCustomDevTools) {
                this.devtoolsUrl = this.startServer();
            } else {
                this.devtoolsUrl = vs.window.withProgress({
                    location: vs.ProgressLocation.Notification,
                    title: startingTitle,
                }, async () => this.startServer());
            }

        }

        const url = await this.devtoolsUrl;

        this.setStartedStatusBar(url);

        return url;
    }

    public getDevToolsLocation(pageId: string | undefined | null): any {
        if (pageId === null)
            return "external";
    }

    private showError(e: any) {
        this.logger.error(e);
        void vs.window.showErrorMessage(`${e}`);
    }

    private getCacheBust(): string {
        return 'cacheBust';
    }

    private getDefaultQueryParams(): { [key: string]: string | undefined } {
        return {
            cacheBust: this.getCacheBust(),
            ide: "VSCode",
        };
    }

    private buildQueryString(queryParams: { [key: string]: string | undefined }): string {
        return Object.keys(queryParams)
            .filter((key) => queryParams[key] !== undefined)
            .map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(queryParams[key] ?? "")}`)
            .join("&");
    }

    private async buildDevToolsUrl(baseUrl: string, queryParams: { [key: string]: string | undefined }, vmServiceUri?: string, clientVmServiceUri?: string) {
        queryParams = {
            ...this.getDefaultQueryParams(),
            ...queryParams,
        };

        // Handle new Path URL DevTools.
        let path = "";

        if (vmServiceUri) {
            /**
             * In some environments (for ex. g3), the VM Service/DDS could be running on
             * the end user machine (eg. Mac) while the extension host is an SSH remote
             * (eg. Linux).
             *
             * `clientVmServiceUri` indicates a URI that is already accessible on the end
             * user machine without forwarding. `vmServiceUri` indicates a URI that is
             * accessible to the extension host.
             *
             * If a `clientVmServiceUri` exists, use it directly instead of trying to
             * forward a URI from the extension host.
             */
            if (clientVmServiceUri) {
                queryParams.uri = clientVmServiceUri;
            } else {
                const exposedUrl = await envUtils.exposeUrl(vmServiceUri, this.logger);
                queryParams.uri = exposedUrl;
            }
        }

        const paramsString = this.buildQueryString(queryParams);
        const urlPathSeperator = baseUrl.endsWith("/") ? "" : "/";
        return `${baseUrl}${urlPathSeperator}${path}?${paramsString}`;
    }

    /// Starts the devtools server and returns the URL of the running app.
    private startServer(hasReinstalled = false): Promise<string> {
        return new Promise<string>(async (resolve, reject) => {
            if (this.service) {
                try {
                    this.service.dispose();
                    this.service = undefined;
                    this.devtoolsUrl = undefined;
                } catch (e) {
                    this.logger.error(e);
                }
            }
            // const service = this.service = new DevToolsService(this.logger, this.context.workspaceContext, undefined, undefined);
            // this.disposables.push(service);
            // await service.connect();

            // service.registerForServerStarted((n) => {


            //     // Finally, trigger a check of extensions
            //     // For initial testing, extension recommendations are allow-list. This comes from config so it can be overridden
            //     // by the user to allow testing the whole flow before being shipped in the list.
            //     //
            //     // Adding "*" to the list allows all extension identifiers, useful for testing.
            //     const defaultAllowList: string[] = [
            //         "serverpod.serverpod",
            //     ];
            //     const effectiveAllowList = defaultAllowList;


            //     portToBind = n.port;
            //     resolve(`http://${n.host}:${n.port}/`);
            // });

            // service.process?.on("close", async (code) => {
            //     this.devtoolsUrl = undefined;
            //     this.setNotStartedStatusBar();
            //     if (code && code !== 0 && !this.isShuttingDown) {
            //         // Reset the port to 0 on error in case it was from us trying to reuse the previous port.
            //         portToBind = 0;
            //         const errorMessage = `${devtoolsPackageName} exited with code ${code}.`;
            //         this.logger.error(errorMessage);

            //         // If we haven't tried reinstalling, prompt to retry.
            //         if (!hasReinstalled) {
            //             const resp = await vs.window.showErrorMessage(`${errorMessage} Would you like to try again?`, tryAgainAction, skipAction);
            //             if (resp === tryAgainAction) {
            //                 try {
            //                     resolve(await this.startServer(true));
            //                 } catch (e) {
            //                     reject(e);
            //                 }
            //                 return;
            //             }
            //         }

            //         reject(errorMessage);
            //     }
            // });
        });
    }

    public dispose(): any {
        this.isShuttingDown = true;
        disposeAll(this.disposables);
    }
}

// /// Handles running the DevTools process (via pub, or dart).
// ///
// /// This is not used for internal workspaces (see startDevToolsFromDaemon).
// class DevToolsService extends StdIOService<UnknownNotification> {
//     public readonly capabilities = DevToolsServerCapabilities.empty;

//     constructor(
//         logger: Logger,
//         private readonly workspaceContext: DartWorkspaceContext,
//         private readonly toolingDaemon: DartToolingDaemon | undefined,
//         private readonly dartCapabilities: DartCapabilities,
//     ) {
//         super(new CategoryLogger(logger, LogCategory.DevTools), config.maxLogLineLength);
//     }

//     public async connect(): Promise<void> {
//         const workspaceContext = this.workspaceContext;
//         const toolingDaemon = this.toolingDaemon;
//         const dartCapabilities = this.dartCapabilities;

//         const dartVm = path.join(workspaceContext.sdks.dart, dartVMPath);
//         const customDevTools = config.customDevTools;

//         // Used for both `'dart devtools' and custom devtools
//         const devToolsArgs = [
//             "--machine",
//             "--allow-embedding",
//         ];

//         if (toolingDaemon) {
//             const dtdUri = await toolingDaemon.dtdUri;
//             if (dtdUri) {
//                 devToolsArgs.push("--dtd-uri");
//                 devToolsArgs.push(dtdUri);
//                 if (this.dartCapabilities.supportsDevToolsDtdExposedUri) {
//                     const exposedDtdUri = await envUtils.exposeUrl(dtdUri, this.logger);
//                     if (exposedDtdUri !== dtdUri) {
//                         devToolsArgs.push("--dtd-exposed-uri");
//                         devToolsArgs.push(exposedDtdUri);
//                     }
//                 }
//             }
//         }

//         const executionInfo = customDevTools?.path ?
//             {
//                 args: ["serve", ...(customDevTools.args ?? [])],
//                 cwd: customDevTools.path,
//                 env: customDevTools.env,
//                 executable: path.join(customDevTools.path, customDevTools.legacy ? devToolsToolLegacyPath : devToolsToolPath),

//             }
//             : dartCapabilities.supportsDartDevTools
//                 ? usingCustomScript(
//                     dartVm,
//                     ["devtools"],
//                     workspaceContext.config?.flutterDevToolsScript,
//                 )
//                 : getPubExecutionInfo(dartCapabilities, workspaceContext.sdks.dart, ["global", "run", "devtools"]);

//         const binPath = executionInfo.executable;
//         const binArgs = [...executionInfo.args, ...devToolsArgs];
//         const binCwd = executionInfo.cwd;
//         const binEnv = executionInfo.env;

//         // Store the port we'll use for later so we can re-bind to the same port if we restart.
//         portToBind = config.devToolsPort  // Always config first
//             || portToBind;                // Then try the last port we bound this session

//         if (portToBind && !customDevTools?.path) {
//             binArgs.push("--port");
//             binArgs.push(portToBind.toString());
//         }

//         this.registerForServerStarted((n) => {
//             if (n.protocolVersion)
//                 this.capabilities.version = n.protocolVersion;
//             this.additionalPidsToTerminate.push(n.pid);
//         });

//         this.createProcess(binCwd, binPath, binArgs, { toolEnv: getToolEnv(), envOverrides: binEnv });
//     }

//     protected shouldHandleMessage(message: string): boolean {
//         return message.startsWith("{") && message.endsWith("}");
//     }

//     // TODO: Remove this if we fix the DevTools server (and rev min version) to not use method for
//     // the server.started event.
//     protected isNotification(msg: any): boolean { return msg.event || msg.method === "server.started"; }

//     protected async handleNotification(evt: UnknownNotification): Promise<void> {
//         switch ((evt as any).method || evt.event) {
//             case "server.started":
//                 await this.notify(this.serverStartedSubscriptions, evt.params as ServerStartedNotification);
//                 break;

//         }
//     }

//     private serverStartedSubscriptions: Array<(notification: ServerStartedNotification) => void> = [];

//     public registerForServerStarted(subscriber: (notification: ServerStartedNotification) => void): vs.Disposable {
//         return this.subscribe(this.serverStartedSubscriptions, subscriber);
//     }

//     public vmRegister(request: { uri: string }): Thenable<any> {
//         return this.sendRequest("vm.register", request);
//     }

//     public async discoverExtensions(projectRoots: string[]): Promise<{ [key: string]: ProjectExtensionResults }> {
//         return this.sendRequest("vscode.extensions.discover", {
//             rootPaths: projectRoots,
//         });
//     }
// }

export interface ServerStartedNotification {
    host: string;
    port: number;
    pid: number;
    protocolVersion: string | undefined
}

interface DevToolsOptions {
    embed?: never;
    location?: DevToolsLocation;
    reuseWindows?: boolean;
    notify?: boolean;
    pageId?: string | null; // undefined = unspecified (use default), null = force external so user can pick any
    inspectorRef?: string;
    commandSource?: string;
    triggeredAutomatically?: boolean;
}

interface ProjectExtensionResults {
    extensions: ExtensionResult[];
    parseErrors: Array<{ packageName: string, error: any }>;
}

interface ExtensionResult {
    packageName: string;
    extension: string;
}

export type DevToolsLocation = "beside" | "active" | "external";

export interface DevToolsLocations {
    [key: string]: DevToolsLocation | undefined
}
