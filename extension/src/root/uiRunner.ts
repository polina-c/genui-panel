// import { EmittingLogger, logToConsole, nullLogger } from "../shared/logging";
// import { StdIOService } from "../shared/services/stdio_service";

// export class UiRunner extends StdIOService<{ type: string }> {
//     constructor(uiAppDirectory: string) {
//         console.log("!!!!!!!!!!!! UiRunner constructor");
//         const logger = new EmittingLogger();
//         logger.onLog((m) => { console.log("!!!!!!!! " + m.toLine(1000)); });
//         logger.info("!!!! test logging");
//         super(logger, 1000, true, true, true, "uiRunnerLogFile.txt");
//         const executable = "python3";
//         const args = ["-m", "http.server", this.port];
//         this.createProcess(uiAppDirectory, executable, args, {});
//         console.log("!!!!!!!!!!!! UiRunner constructor done");
//     }

//     public port = "50006";

//     protected shouldHandleMessage(message: string): boolean {
//         throw new Error("Method not implemented.");
//     }
//     protected handleNotification(evt: { type: string; }): Promise<void> {
//         throw new Error("Method not implemented.");
//     }
// }
