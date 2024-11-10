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

  //   private _getHtmlContent(webview: vscode.Webview): string {

  //     // const indexUri = webview.asWebviewUri(
  //     //   vscode.Uri.joinPath(this._extensionUri, "assets", "web", "index.html")
  //     // );

  //     const heightPx = 1200; // 100% does not work here, because of infinite vertical size of container.

  //     return `
  // <!DOCTYPE html>
  // <html>
  // <head>
  // 	<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
  // 	<script>${everyScreenJsScript}</script>
  // </head>
  // <body>
  //   <button onclick="messageToDart()">Message to Dart :)</ button>
  //   <br/>
  //   <br/>
  //   <br/>
  //   <iframe
  //     id="sidebar"
  //     src="${Config.sidebarUrl}"
  //     width="100%"
  //     height="${heightPx}px"
  //     style="border: none;"
  //     allow="clipboard-read; clipboard-write; cross-origin-isolated">
  //   </iframe>
  // </body>
  // </html>
  // `;
  //   }
}
