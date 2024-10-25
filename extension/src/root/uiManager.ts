import { nullLogger } from "../shared/logging";
import { StdIOService } from "../shared/services/stdio_service";

export class UiRunner extends StdIOService<{ type: string }> {
    protected shouldHandleMessage(message: string): boolean {
        throw new Error("Method not implemented.");
    }
    protected handleNotification(evt: { type: string; }): Promise<void> {
        throw new Error("Method not implemented.");
    }
    constructor(uiAppDirectory: string) {
        super(nullLogger, 1000, true, true, true, "uiRunnerLogFile.txt");
        const executable = "python3";
        const args = ["-m", "http.server", this.port];
        this.createProcess(uiAppDirectory, executable, args, {});
    }

    private port = "50001";
}


