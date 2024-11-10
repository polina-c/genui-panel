import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { htmlWithFlutterIFrame } from '../shared/iframe_with_flutter';
import { RevealCallback } from '../shared/reveal';
import { messageTypes } from '../shared/cross_app_constants';


export function showContentPanel(prompt: string, revealCallback: RevealCallback) {
	const column = vscode.window.activeTextEditor
		? vscode.window.activeTextEditor.viewColumn
		: undefined;

	const panel = vscode.window.createWebviewPanel(
		'genUiContent',
		"GenUI",
		column || vscode.ViewColumn.One,
		{
			enableScripts: true,
			retainContextWhenHidden: true,
		},
	);

	panel.webview.options = {
		enableScripts: true,
		enableCommandUris: true,
	};

	const url = Config.contentUrl(prompt);
	panel.webview.html = htmlWithFlutterIFrame(url);

	panel.webview.onDidReceiveMessage(
		(message) => {
			console.log(`!!!!!! node content, got message, ${typeof (message)}, ${message}`);
			const data = JSON.parse(message?.data);
			const type = data?.type;

			console.log(`!!!!!! node content, type: ${type}, prompt: ${data?.prompt}`);

			if (type === messageTypes.reveal) {
				revealCallback(data?.prompt);
			}
		},
	);
}

