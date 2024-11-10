import * as vscode from "vscode";
import { showContentPanel } from "./contentPanel";
import { Config } from "../shared/config";
import { everyScreenJsScript, htmlWithFlutterIFrame } from "../shared/iframe_with_flutter";
import { messageTypes } from "../shared/cross_app_constants";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  constructor() { }

  private _view?: vscode.WebviewView;

  private get _webview(): vscode.Webview { return this._view!.webview; }

  private handleReveal(prompt: string) {
    console.log(`!!!!!! node sidebar, handleReveal, ${prompt}`);
    this._webview.postMessage({
      type: messageTypes.reveal,
      to: 'dart',
      prompt: prompt,
    });
  }

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {
    this._view = webviewView;

    this._webview.options = {
      enableScripts: true,
      enableCommandUris: true,
    };
    this._webview.html = htmlWithFlutterIFrame(Config.sidebarUrl);

    this._webview.onDidReceiveMessage(
      (message) => {
        console.log(`!!!!!! node sidebar, got message, ${typeof (message)}, ${message}`);
        const data = JSON.parse(message?.data);
        const type = data?.type;

        console.log(`!!!!!! node sidebar, type: ${type}, prompt: ${data?.prompt}`);

        if (type === messageTypes.generateUi) {
          showContentPanel(data?.prompt, this.handleReveal);
        }
      },
    );
  }
}
