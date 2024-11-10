import * as vscode from "vscode";
import { ContentPanel } from "./contentPanel";
import { Config } from "../shared/config";
import { everyScreenJsScript, htmlWithFlutterIFrame } from "../shared/iframe_with_flutter";
import { generateContentMessageType } from "../shared/cross_app_constants";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  constructor(private _extensionUri: vscode.Uri) { }

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {
    webviewView.webview.options = {
      enableScripts: true,
      enableCommandUris: true,
    };
    webviewView.webview.html = htmlWithFlutterIFrame(Config.sidebarUrl);

    webviewView.webview.onDidReceiveMessage(
      (message) => {
        console.log(`!!!!!! node sidebar, got message, ${typeof (message)}, ${message}`);
        const data = JSON.parse(message?.data);
        const type = data?.type;

        console.log(`!!!!!! node sidebar, type: ${type}, prompt: ${data?.prompt}`);

        if (type === generateContentMessageType) {
          ContentPanel.show(data?.prompt);
        }
      },
    );
  }
}
