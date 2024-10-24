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

    return `
<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <iframe
    src="http://localhost:5000"
    width="100%"
    style="border: none;"
    allow="clipboard-read; clipboard-write; cross-origin-isolated">
  </iframe>
  hello
</body>
</html>
`;
  }
}
