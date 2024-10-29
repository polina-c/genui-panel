import * as vscode from "vscode";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  private _view?: vscode.WebviewView;

  private _frameId = 'flutterAppFrame';

  constructor(private readonly _extensionUri: vscode.Uri, port: string) {
    this._flutterAppOrigin = `http://localhost:${port}`;
  }

  private _flutterAppOrigin: string;

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {
    this._view = webviewView;

    webviewView.webview.options = {
      // Allow scripts in the webview
      enableScripts: true,
      localResourceRoots: [this._extensionUri],
    };
    webviewView.webview.html = this._getHtmlContent(webviewView.webview);
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
  <iframe
    id="${this._frameId}"
    src="${this._flutterAppOrigin}"
    width="100%"
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
  if (origin !== '${this._flutterAppOrigin}') return;
  console.log('!!!!!! passing to vscode');
  vscodeInJs.postMessage(message);
});
`;
  }
}
