import * as vscode from "vscode";
import { ContentPanel } from "./contentPanel";
import { Config } from "../shared/config";
import { everyScreenJsScript } from "../shared/js_script";

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

        if (message.includes('generate')) {
          ContentPanel.show(this._extensionUri, Config.uiUrl);
        }
        vscode.window.showInformationMessage(message);

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
	<script>${everyScreenJsScript}</script>
</head>
<body>
  <button onclick="messageToDart()">Message to Dart :)</ button>
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
}
