import { EmittingLogger, logToConsole, nullLogger } from "../shared/logging";
import { StdIOService } from "../shared/services/stdio_service";
import * as vscode from "vscode";

export class UiRunner extends StdIOService<{ type: string }> {
    constructor(extensionUri: vscode.Uri) {
        console.log("!!!!!!!!!!!! UiRunner constructor");
        const logger = new EmittingLogger();
        logger.onLog((m) => { console.log("!!!!!!!! " + m.toLine(1000)); });
        logger.info("!!!! test logging");
        super(logger, 1000, true, true, true, "uiRunnerLogFile.txt");

        // const uiAppDirectory = vscode.Uri.joinPath(extensionUri, "assets", "web").toString().replace('file://', '');
        // const executable = "python3";
        // const args = ["-m", "http.server", this.port];

        const uiAppDirectory = vscode.Uri.joinPath(extensionUri, "assets", "flutter").toString().replace('file://', '');
        const executable = "flutter";
        const args = ["run", "-d", "web-server", `--web-port=${this.port}`];

        this.createProcess(uiAppDirectory, executable, args, {});
        console.log("!!!!!!!!!!!! UiRunner constructor done");
    }

    public port = "5001";

    protected shouldHandleMessage(message: string): boolean {
        throw new Error("Method not implemented.");
    }
    protected handleNotification(evt: { type: string; }): Promise<void> {
        throw new Error("Method not implemented.");
    }
}
