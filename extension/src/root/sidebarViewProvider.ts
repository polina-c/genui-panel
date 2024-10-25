import * as vscode from "vscode";

export class SidebarViewProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  private _view?: vscode.WebviewView;

  constructor(private readonly _extensionUri: vscode.Uri, private _port: string) { }

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

    // const indexUri = webview.asWebviewUri(
    //   vscode.Uri.joinPath(this._extensionUri, "assets", "web", "index.html")
    // );

    return `
<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <iframe
    src="http://localhost:${this._port}"
    width="100%"
    style="border: none;"
    allow="clipboard-read; clipboard-write; cross-origin-isolated">
  </iframe>
</body>
</html>
`;
  }
}
