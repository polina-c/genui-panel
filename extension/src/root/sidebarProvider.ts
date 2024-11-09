import * as vscode from "vscode";
import { ContentPanel } from "./contentPanel";
import { Config } from "../shared/config";

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
    webviewView.webview.html = this._getHtmlContent(webviewView.webview);
    webviewView.webview.onDidReceiveMessage(
      (message) => {
        message = JSON.stringify(message); // just in case
        console.log('!!!!!! node got message', message);
        if (message.includes('hello from node to webview about')) {
          console.log('!!!!!! exiting on recursion');
          return;
        }
        if (message.includes('generate')) {
          ContentPanel.show(this._extensionUri, Config.uiUrl);
        }
        vscode.window.showInformationMessage(message);

        console.log('!!!!!! node sending message to webview...');
        webviewView.webview.postMessage({ type: `hello from node to webview about ${message}` });
      },
    );
  }

  private _getHtmlContent(webview: vscode.Webview): string {

    // const indexUri = webview.asWebviewUri(
    //   vscode.Uri.joinPath(this._extensionUri, "assets", "web", "index.html")
    // );

    const heightPx = 1200; // 100% does not work here, because of infinite vertical size of container.

    return `
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
	<script>${this._getJsScriptText()}</script>
</head>
<body>
  <button onclick="messageToDart()">Message to Dart</ button>
  <br/>
  <br/>
  <br/>
  <iframe
    id="sidebar"
    src="${Config.sidebarUrl}"
    width="100%"
    height="${heightPx}px"
    style="border: none;"
    allow="clipboard-read; clipboard-write; cross-origin-isolated">
  </iframe>
</body>
</html>
`;
  }

  private _getJsScriptText(): string {
    return `
const vscodeInJs = acquireVsCodeApi();

function messageToDart() {

  console.log('!!!!!! node sidebar: posting message to dart...');
  document.getElementById('sidebar').contentWindow.postMessage('hello from webview to dart', '*');
  console.log('!!!!!! node sidebar: posting message to dart done.');
}

window.addEventListener('message', (event) => {
  console.log('!!!!!! node sidebar: got message', event);
  let message = JSON.stringify(event.data);
  if (message.includes('(from webview)')) return;
  message = message + '(from webview)';
  let origin = event.origin;
  console.log('!!!!!! node sidebar: posting message to dart...', message, origin);
  vscodeInJs.postMessage(message);
  console.log('!!!!!! node sidebar: posted to vscodeInJs');
  window.postMessage(message);
  console.log('!!!!!! node sidebar: posted message to dart.', message, origin);
});
`;
  }
}
