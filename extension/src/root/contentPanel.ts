import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { everyScreenJsScript, htmlWithFlutterIFrame } from '../shared/iframe_with_flutter';

export class ContentPanel {
	constructor() { }

	public static readonly viewType = 'genUiContent';

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

		const url = Config.contentUrl(prompt);
		panel.webview.html = htmlWithFlutterIFrame(url);
	}
}

