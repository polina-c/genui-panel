import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { htmlWithIFrame } from '../shared/iframe_with_flutter';
import { RevealCallback } from '../shared/reveal';
import { messageTypes, parseMessageData } from '../shared/in_ide_message';

let next = 1;

function getColumnForNewWebview(openOnSide: boolean) {
	if (openOnSide) {
		return vscode.ViewColumn.Beside;
	}

	const column = vscode.window.activeTextEditor
		? vscode.window.activeTextEditor.viewColumn
		: undefined;

	return column || vscode.ViewColumn.One;
}


export function showContentPanel(
	prompt: string,
	numberOfOptions: number,
	openOnSide: boolean,
	uiSizePx: number | undefined,
	revealCallback: RevealCallback,
) {
	const panel = vscode.window.createWebviewPanel(
		'genUiContent',
		`Gen UI ${next++}`,
		getColumnForNewWebview(openOnSide),
		{
			enableScripts: true,
			retainContextWhenHidden: true,
		},
	);

	panel.webview.options = {
		enableScripts: true,
		enableCommandUris: true,
	};

	const url = Config.contentUrl(prompt, numberOfOptions, uiSizePx);
	panel.webview.html = htmlWithIFrame(url);

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

