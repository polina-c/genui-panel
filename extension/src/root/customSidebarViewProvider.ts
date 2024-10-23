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
    // Get the local path to main script run in the webview,
    // then convert it to a uri we can use in the webview.
    const scriptUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "main.js")
    );

    const styleResetUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "reset.css")
    );
    const styleVSCodeUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "vscode.css")
    );

    // Same for stylesheet
    const stylesheetUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this._extensionUri, "assets", "main.css")
    );

    // Use a nonce to only allow a specific script to be run.
    const nonce = getNonce();

    return `
<!DOCTYPE html>
<html>

<body>
    <div id="frame1" style="overflow: hidden"><iframe src="http://localhost:5000" title="Dynamic"
            style="position: relative; top: -10px"></iframe></div>

    Enter URL of the Gen UI frame:</br>
    <input type="text" id="url1" style='width:30em' value="http://localhost:57338/#?frame=1" />
    <button type="button" onclick="embedFlutterHere(1)">Show</button>
    </br>
    <div id="frame1" style="overflow: hidden">frame be rendered here</div>

    </br>
    </br>

    Enter URL of the Gen UI frame:</br>
    <input type="text" id="url2" style='width:30em' value="http://localhost:57338/#?frame=2" />
    <button type="button" onclick="embedFlutterHere(2)">Show</button>
    </br>
    <div id="frame2" style="overflow: hidden">frame be rendered here</div>

    </br>
    </br>

    Enter URL of the Gen UI frame:</br>
    <input type="text" id="url3" style='width:30em' value="http://localhost:57338/#?frame=3" />
    <button type="button" onclick="embedFlutterHere(3)">Show</button>
    </br>
    <div id="frame3" style="overflow: hidden">frame be rendered here</div>

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
