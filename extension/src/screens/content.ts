import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { htmlWithIFrame } from '../shared/iframe_with_flutter';
import { CallbackToSidebar } from '../shared/reveal';
import { isMessageToSidebar, parseMessageData } from '../shared/in_ide_message';

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
	extensionUri: vscode.Uri,
	callbackToPanel: CallbackToSidebar,
) {
	const panelName = `UI_${next++}.genui`;
	const panel = vscode.window.createWebviewPanel(
		'genUiContent',
		panelName,
		getColumnForNewWebview(openOnSide),
		{
			enableScripts: true,
			retainContextWhenHidden: true,

		},
	);

	panel.iconPath = vscode.Uri.joinPath(extensionUri, "assets", "leaf.svg");

	panel.webview.options = {
		enableScripts: true,
		enableCommandUris: true,
	};

	const url = Config.contentUrl(prompt, numberOfOptions, uiSizePx, panelName);
	panel.webview.html = htmlWithIFrame(url);

	panel.webview.onDidReceiveMessage(
		(message) => {
			console.log(`!!!!!! node content, got message, ${typeof (message)}, ${message}`);
			const data: any = parseMessageData(message);
			if (isMessageToSidebar(data)) {
				callbackToPanel(data);
			}
		}
	);
}
