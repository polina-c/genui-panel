import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { everyScreenJsScript } from '../shared/js_script';

export class ContentPanel {
	constructor() { }

	public static readonly viewType = 'catCodicons';

	public static show() {
		const column = vscode.window.activeTextEditor
			? vscode.window.activeTextEditor.viewColumn
			: undefined;

		const panel = vscode.window.createWebviewPanel(
			ContentPanel.viewType,
			"GenUI",
			column || vscode.ViewColumn.One
		);

		panel.webview.options = {
			enableScripts: true,
			enableCommandUris: true,
		};
		panel.webview.html = this._getHtmlContent();
	}

	private static _getHtmlContent(): string {

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
${Config.contentUrl}
  <iframe
    src="${Config.contentUrl}"
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

