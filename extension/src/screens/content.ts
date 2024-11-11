import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { htmlWithFlutterIFrame } from '../shared/iframe_with_flutter';
import { RevealCallback } from '../shared/reveal';
import { messageTypes, parseMessageData } from '../shared/in_ide_message';

let next = 1;

function getColumnForNewWebview(sideBySide: boolean) {
	if (sideBySide) {
		return vscode.ViewColumn.Beside;
	}

	const column = vscode.window.activeTextEditor
		? vscode.window.activeTextEditor.viewColumn
		: undefined;

	return column || vscode.ViewColumn.One;
}


export function showContentPanel(prompt: string, numberOfOptions: number, sideBySide: boolean, revealCallback: RevealCallback) {
	const panel = vscode.window.createWebviewPanel(
		'genUiContent',
		`Gen UI ${next++}`,
		getColumnForNewWebview(sideBySide),
		{
			enableScripts: true,
			retainContextWhenHidden: true,
		},
	);

	panel.webview.options = {
		enableScripts: true,
		enableCommandUris: true,
	};

	const url = Config.contentUrl(prompt, numberOfOptions);
	panel.webview.html = htmlWithFlutterIFrame(url);

	panel.webview.onDidReceiveMessage(
		(message) => {
			console.log(`!!!!!! node content, got message, ${typeof (message)}, ${message}`);
			const data: any = parseMessageData(message);
			const type = data?.type;

			console.log(`!!!!!! node content, type: ${type}, prompt: ${data?.prompt}`);

			if (type === messageTypes.reveal) {
				revealCallback();
			}
		},
	);
}

