import { IAmDisposable } from "../shared/interfaces";
import { nullLogger } from "../shared/logging";
import { StdIOService } from "../shared/services/stdio_service";

export class UiRunner extends StdIOService<{ type: string }> {
    constructor() {
        super(nullLogger, 1000, true, true, true, "uiRunnerLogFile.txt");
        const executable = "python3 -m http.server 50001 --directory assets/web";
        this.createProcess(".", executable, [], {});
    }

    protected shouldHandleMessage(message: string): boolean {
        return (message.startsWith("{") && message.endsWith("}"))
            || (message.startsWith("[{") && message.endsWith("}]"));
    }
    protected isNotification(msg: any): boolean { return !!(msg.type || msg.event); }
    protected isResponse(msg: any): boolean { return false; }

    protected async processUnhandledMessage(message: string): Promise<void> {
        await this.notify(this.unhandledMessageSubscriptions, message);
    }

    private unhandledMessageSubscriptions: Array<(notification: string) => void> = [];
    public registerForUnhandledMessages(subscriber: (notification: string) => void): IAmDisposable {
        return this.subscribe(this.unhandledMessageSubscriptions, subscriber);
    }

    protected async handleNotification(evt: any): Promise<void> {
        // console.log(JSON.stringify(evt));
        switch (evt.event) {
            case "ui.startedProcess":
                await this.notify(this.testStartedProcessSubscriptions, evt.params as TestStartedProcess);
                break;
        }

        // Send all events to the editor.
        await this.notify(this.allTestNotificationsSubscriptions, evt);
    }

    // Subscription lists.

    private testStartedProcessSubscriptions: Array<(notification: TestStartedProcess) => void> = [];
    private allTestNotificationsSubscriptions: Array<(notification: any) => void> = [];

    // Subscription methods.

    public registerForTestStartedProcess(subscriber: (notification: TestStartedProcess) => void): IAmDisposable {
        return this.subscribe(this.testStartedProcessSubscriptions, subscriber);
    }

    public registerForAllTestNotifications(subscriber: (notification: { type: string }) => void): IAmDisposable {
        return this.subscribe(this.allTestNotificationsSubscriptions, subscriber);
    }
}

export interface TestStartedProcess {
    observatoryUri: string;
}
