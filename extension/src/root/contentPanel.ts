import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { htmlWithFlutterIFrame } from '../shared/iframe_with_flutter';
import { RevealCallback } from '../shared/reveal';
import { messageTypes, parseMessageData } from '../shared/in_ide_message';

let next = 1;

export function showContentPanel(prompt: string, revealCallback: RevealCallback) {
	const column = vscode.window.activeTextEditor
		? vscode.window.activeTextEditor.viewColumn
		: undefined;

	const panel = vscode.window.createWebviewPanel(
		'genUiContent',
		`Gen UI ${next}`,
		column || vscode.ViewColumn.One,
		{
			enableScripts: true,
			retainContextWhenHidden: true,
		},
	);

	next++;

	panel.webview.options = {
		enableScripts: true,
		enableCommandUris: true,
	};

	const url = Config.contentUrl(prompt);
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

