import * as vscode from "vscode";
import { showContentPanel } from "./content";
import { Config } from "../shared/config";
import { everyScreenJsScript, htmlWithFlutterIFrame } from "../shared/iframe_with_flutter";
import { messageLocations, messageTypes, parseMessageData } from "../shared/in_ide_message";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  constructor() { }

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {
    const view = webviewView.webview;

    view.options = {
      enableScripts: true,
      enableCommandUris: true,
    };
    view.html = htmlWithFlutterIFrame(Config.sidebarUrl);

    view.onDidReceiveMessage(
      (message) => {
        console.log(`!!!!!! node sidebar, got message, ${typeof (message)}, ${message}`);
        const data: any = parseMessageData(message);
        const type = data?.type;

        console.log(`!!!!!! node sidebar, type: ${type}, prompt: ${data?.prompt}`);

        if (type === messageTypes.generateUi) {
          showContentPanel(data?.prompt ?? '', data?.numberOfOptions ?? 1, () => view.postMessage(
            {
              type: messageTypes.reveal,
              to: messageLocations.dart,
              prompt: data?.prompt,
            }
          ));
        }
      },
    );
  }
}
