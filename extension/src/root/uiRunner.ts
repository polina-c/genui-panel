import { EmittingLogger } from "../shared/logging";
import { StdIOService } from "../shared/services/stdio_service";
import * as vscode from "vscode";
import { LogMessage } from "../shared/interfaces";

export class UiRunner extends StdIOService<{ type: string }> {
    constructor(extensionUri: vscode.Uri) {
        console.log("!!!!!!!!!!!! UiRunner constructor");
        const logger = new EmittingLogger();
        super(logger, 1000, true, true, true, undefined);
        this.port = "5001";
        this.done = false;

        logger.onLog((logMessage) => this.handleLogMessage(logMessage));
        logger.info("!!!! test logging");

        // const uiAppDirectory = vscode.Uri.joinPath(extensionUri, "assets", "web").toString().replace('file://', '');
        // const executable = "python3";
        // const args = ["-m", "http.server", this.port];

        const uiAppDirectory = vscode.Uri.joinPath(extensionUri, "assets", "flutter_app").toString().replace('file://', '');
        console.log("!!!!!!!!!!!! uiAppDirectory: " + uiAppDirectory);
        const executable = "flutter";
        const args = ["run", "-d", "web-server", `--web-port=${this.port}`];

        this.createProcess(uiAppDirectory, executable, args, {});
        console.log("!!!!!!!!!!!! UiRunner constructor done");
    }

    public port: string;

    public isDone(): boolean {
        return this.done;
    }
    private done: boolean;

    protected shouldHandleMessage(message: string): boolean {
        return true;
    }

    protected async handleNotification(evt: { type: string; }): Promise<void> {
        const message = JSON.stringify(evt);
        console.log(`!!!! notification from runner:\n${message}`);
    }

    private handleLogMessage(logMessage: LogMessage) {
        const message = logMessage.toLine(1000);
        console.log(`!!!! log from runner: ${message}`);
        if (this.done) return;

        const startedMessage = `lib/main.dart is being served at http://localhost:`;
        const terminatedMessage = `Process flutter terminated!`;

        if (message.includes(startedMessage) || message.includes(terminatedMessage)) {
            console.log(`!!!! done: ${message}`);
            this.done = true;
        }
    }
}
