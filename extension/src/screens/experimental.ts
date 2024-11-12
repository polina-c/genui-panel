import * as vscode from 'vscode';
import { Config } from '../shared/config';
import { htmlWithIFrame as htmlWithIFrame } from '../shared/iframe_with_flutter';
import { CallbackToPanel } from '../shared/reveal';
import { messageTypes, parseMessageData } from '../shared/in_ide_message';




export function showExperimentalPanel() {
	const panel = vscode.window.createWebviewPanel(
		'genUiExperiment',
		`experiment`,
		vscode.ViewColumn.One,
		{
			enableScripts: true,
			retainContextWhenHidden: true,
		},
	);

	panel.webview.options = {
		enableScripts: true,
		enableCommandUris: true,
	};

	const url = `https://genui.corp.google.com/&output=embed`;
	panel.webview.html = htmlWithIFrame(url);
}

