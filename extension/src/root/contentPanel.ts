import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { everyScreenJsScript, htmlWithFlutterIFrame } from '../shared/iframe_with_flutter';

export class ContentPanel {
	constructor() { }

	public static readonly viewType = 'catCodicons';

	public static show(prompt: string) {
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
		panel.webview.html = this._getHtmlContent(prompt);
	}

	private static _getHtmlContent(prompt: string): string {
		const url = Config.contentUrl(prompt);
		return htmlWithFlutterIFrame(url);

		// 		return `
		// <!DOCTYPE html>
		// <html>
		// <head>
		// 	<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
		// 	<script>${everyScreenJsScript}</script>
		// </head>
		// <body>
		//   <iframe
		//     src="${url}"
		//     width="100%"
		//     height="${heightPx}px"
		//     style="border: none;"
		//     allow="clipboard-read; clipboard-write; cross-origin-isolated">
		//   </iframe>
		// </body>
		// </html>
		// `;
	}
}

