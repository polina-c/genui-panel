import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';

/**
 * Manages webview panels
 */
export class AngularView {
    /**
     * Track the currently panel. Only allow a single panel to exist at a time.
     */
    public static currentPanel: AngularView | undefined;

    private static readonly viewType = 'angular';

    private readonly panel: vscode.WebviewPanel;
    private readonly extensionPath: string;
    private readonly builtAppFolder: string;
    private disposables: vscode.Disposable[] = [];

    public static createOrShow(extensionPath: string) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;

        // If we already have a panel, show it.
        // Otherwise, create angular panel.
        if (AngularView.currentPanel) {
            AngularView.currentPanel.panel.reveal(column);
        } else {
            AngularView.currentPanel = new AngularView(
                extensionPath,
                column || vscode.ViewColumn.One,
            );
        }
        return AngularView.currentPanel;
    }

    public static updateTitle(extensionPath: string) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;

        // If we already have a panel, show it.
        // Otherwise, create angular panel.
        if (AngularView.currentPanel) {
            AngularView.currentPanel.panel.reveal(column);
        } else {
            AngularView.currentPanel = new AngularView(
                extensionPath,
                column || vscode.ViewColumn.One,
            );
        }

        AngularView.currentPanel.panel.webview.postMessage({
            command: 'update-title',
            payload: {
                title: `Hello from ${extensionPath} - ${Date().toString()}`,
            },
        });
    }

    private constructor(extensionPath: string, column: vscode.ViewColumn) {
        this.extensionPath = extensionPath;
        this.builtAppFolder = 'dist';

        // Create and show a new webview panel
        this.panel = vscode.window.createWebviewPanel(
            AngularView.viewType,
            'My Angular Webview',
            column,
            {
                // Enable javascript in the webview
                enableScripts: true,

                // And restrict the webview to only loading content from our extension's `media` directory.
                localResourceRoots: [
                    vscode.Uri.file(path.join(this.extensionPath, this.builtAppFolder)),
                ],
            },
        );

        // Set the webview's initial html content
        this.panel.webview.html = this._getHtmlForWebview();

        // Listen for when the panel is disposed
        // This happens when the user closes the panel or when the panel is closed programatically
        this.panel.onDidDispose(() => this.dispose(), null, this.disposables);

        // Handle messages from the webview
        this.panel.webview.onDidReceiveMessage(
            (message) => {
                switch (message.command) {
                    case 'notification':
                        vscode.window.showInformationMessage(message.data.text);
                        vscode.window.showErrorMessage(message.text);
                        return;
                }
            },
            null,
            this.disposables,
        );
    }

    public dispose() {
        AngularView.currentPanel = undefined;

        // Clean up our resources
        this.panel.dispose();

        while (this.disposables.length) {
            const x = this.disposables.pop();
            if (x) {
                x.dispose();
            }
        }
    }

    /**
     * Returns html of the start page (index.html)
     */
    private _getHtmlForWebview() {
        // path to dist folder
        const appDistPath = path.join(this.extensionPath, 'dist');
        const appDistPathUri = vscode.Uri.file(appDistPath);

        // path as uri
        const baseUri = this.panel.webview.asWebviewUri(appDistPathUri);

        // get path to index.html file from dist folder
        const indexPath = path.join(appDistPath, 'index.html');

        // read index file from file system
        let indexHtml = fs.readFileSync(indexPath, { encoding: 'utf8' });

        // update the base URI tag
        indexHtml = indexHtml.replace(
            '<base href="/">',
            `<base href="${String(baseUri)}/">`,
        );

        return indexHtml;
    }
}
