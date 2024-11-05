// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';

import { SidebarProvider } from './root/sidebarProvider';
import { ContentPanel } from './root/contentPanel';

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export async function activate(context: vscode.ExtensionContext) {

	const uiUrl = "http://localhost:8080";  // "https://genui-panel.web.app";

	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log(`The extension "genui-panel" is now active and is working with ${uiUrl}`);

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with registerCommand
	// The commandId parameter must match the command field in package.json
	const disposable = vscode.commands.registerCommand('genui-panel.helloWorld', () => {
		// The code you place here will be executed every time your command is executed
		// Display a message box to the user
		vscode.window.showInformationMessage('Hello World from genui-panel!');
	});

	context.subscriptions.push(disposable);

	console.log(`!!!! starting panel`);
	const provider = new SidebarProvider(context.extensionUri, uiUrl);
	context.subscriptions.push(
		vscode.window.registerWebviewViewProvider(
			SidebarProvider.viewType,
			provider,
			{ webviewOptions: { retainContextWhenHidden: true } }
		)
	);

	// context.subscriptions.push(
	// 	vscode.commands.registerCommand('catCodicons.show', () => {
	// 		ContentPanel.show(context.extensionUri);
	// 	})
	// );


	context.subscriptions.push(
		vscode.commands.registerCommand("genui-panel.menu.view", () => {
			const message = "Menu/Title of extension is clicked !";
			vscode.window.showInformationMessage(message);
		})
	);

	// Command has been defined in the package.json file
	// Provide the implementation of the command with registerCommand
	// CommandId parameter must match the command field in package.json
	const openWebView = vscode.commands.registerCommand('genui-panel.openview', () => {
		// Display a message box to the user
		vscode.window.showInformationMessage('Command " Sidebar View [genui-panel.openview] " called.');
	});

	context.subscriptions.push(openWebView);
}

// This method is called when your extension is deactivated
export function deactivate() { }
