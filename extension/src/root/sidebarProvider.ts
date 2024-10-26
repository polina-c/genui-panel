import * as vscode from "vscode";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  private _view?: vscode.WebviewView;

  constructor(private readonly _extensionUri: vscode.Uri, private _port: string) { }

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {
    this._view = webviewView;

    const path = vscode.Uri.joinPath(this._extensionUri, "assets", "web");
    console.log(`!!!!! ${path}`);
    const localResourceRoots = webviewView.webview.asWebviewUri(path);

    console.log(`!!!!! ${localResourceRoots}`);


    webviewView.webview.options = {
      enableScripts: true,
      localResourceRoots: [path],
      enableCommandUris: true,
      enableForms: true,
    };
    webviewView.webview.html = this.getHtmlContent(path.toString());

  }

  private getHtmlContent(base: string): string {

    // const indexUri = webview.asWebviewUri(
    //   vscode.Uri.joinPath(this._extensionUri, "assets", "web", "index.html")
    // );

    // console.log('!!!!! accessing app at http://127.0.0.1:' + this._port);

    return `
<!DOCTYPE html>
<html>
<head>
  <base href="${base}/">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="A new Flutter project.">

  <!-- iOS meta tags & icons -->
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="ui">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <title>ui</title>
  <link rel="manifest" href="manifest.json">
</head>
<body>
hello!!!
<img src="favicon.png" alt="A flutter app" width="100" height="100">
  <script src="flutter_bootstrap.js" async></script>
</body>
</html>
`;
  }
}
