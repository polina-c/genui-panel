import * as vscode from "vscode";

export class CustomSidebarViewProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  private _view?: vscode.WebviewView;

  constructor(private readonly _extensionUri: vscode.Uri) { }

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
    webviewView.webview.html = this.getHtmlContent(webviewView.webview);
  }

  private getHtmlContent(webview: vscode.Webview): string {

    const indexUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "web", "index.html")
    );

    const picUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "web", "favicon.png")
    );

    const baseUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "web")
    );

    // Use a nonce to only allow a specific script to be run.
    const nonce = getNonce();

    return `
<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <div id="frame1" style="overflow: hidden">
    <iframe src="http://localhost:5000" title="Dynamic" style=" border: none;"
          allow="clipboard-read; clipboard-write; cross-origin-isolated"></iframe>
  </div>
</body>
</html>
`;
  }
}

function getNonce() {
  let text = "";
  const possible =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for (let i = 0; i < 32; i++) {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return text;
}
