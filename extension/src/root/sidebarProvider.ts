import * as vscode from "vscode";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  constructor() {
    this._flutterAppUri = 'https://genui-panel.web.app';
  }

  private _flutterAppUri: string;

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {

    webviewView.webview.options = {
      // Allow scripts in the webview
      enableScripts: true,
    };
    webviewView.webview.html = this._getHtmlContent(webviewView.webview);
    webviewView.webview.onDidReceiveMessage(
      (message) => {
        console.log('!!!!!! node got message', message);
        vscode.window.showInformationMessage(message);
      },
    );
  }

  private _getHtmlContent(webview: vscode.Webview): string {

    // const indexUri = webview.asWebviewUri(
    //   vscode.Uri.joinPath(this._extensionUri, "assets", "web", "index.html")
    // );

    return `
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
	<script>${this._getJsScriptText()}</script>
</head>
<body>
  flutter iframe hosted at ${this._flutterAppUri}:
  <br>
  <iframe
    src="${this._flutterAppUri}"
    width="100%"
    height="1200px" // 100% doe not work here, because of infinite vertical size of container.
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

window.addEventListener('message', (event) => {
  console.log('!!!!!! got message', event);
  let message = event.data;
  let origin = event.origin;
  console.log('!!!!!! details', message, origin);
  if (origin !== '${this._flutterAppUri}') return;
  console.log('!!!!!! passing to vscode');
  vscodeInJs.postMessage(message);
});
`;
  }
}
