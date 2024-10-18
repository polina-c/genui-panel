import * as vs from "vscode";
import { URI } from "vscode-uri";
// import { DartCapabilities } from "../../../shared/capabilities/dart";
// import { IAmDisposable } from "../../../shared/interfaces";
// import { disposeAll } from "../../../shared/utils";
// import { envUtils } from "../../../shared/vscode/utils";
// import { DevToolsManager } from "../../sdk/dev_tools/manager";


// export class FlutterDtdSidebar implements IAmDisposable {
//     protected readonly disposables: vs.Disposable[] = [];

//     constructor(
//         readonly devTools: DevToolsManager,
//         dartCapabilities: DartCapabilities,
//     ) {
//         const webViewProvider = new MyWebViewProvider(devTools, dartCapabilities);
//         this.disposables.push(vs.window.registerWebviewViewProvider("dartFlutterSidebar", webViewProvider, { webviewOptions: { retainContextWhenHidden: true } }));
//     }

//     public dispose(): any {
//         disposeAll(this.disposables);
//     }
// }

// class MyWebViewProvider implements vs.WebviewViewProvider {
//     public webviewView: vs.WebviewView | undefined;
//     constructor(
//         private readonly devTools: DevToolsManager,
//         private readonly dartCapabilities: DartCapabilities,
//     ) { }

//     public async resolveWebviewView(webviewView: vs.WebviewView, context: vs.WebviewViewResolveContext<unknown>, token: vs.CancellationToken): Promise<void> {
//         this.webviewView = webviewView;

//         await this.devTools.start();
//         let sidebarUrl = await this.devTools.urlFor("editorSidebar");
//         if (!sidebarUrl) {
//             webviewView.webview.html = `
// 			<html>
// 			<body><h1>Sidebar Unavailable</h1><p>The Flutter sidebar requires DevTools but DevTools failed to start.</p></body>
// 			</html>
// 			`;
//             return;
//         }

//         sidebarUrl = await envUtils.exposeUrl(sidebarUrl);
//         const sidebarUri = URI.parse(sidebarUrl);
//         const frameOrigin = `${sidebarUri.scheme}://${sidebarUri.authority}`;
//         const embedFlags = this.dartCapabilities.requiresDevToolsEmbedFlag ? "embed=true&embedMode=one" : "embedMode=one";
//         const pageScript = `
// 		let currentBackgroundColor;
// 		let currentBaseUrl;

// 		function setIframeSrc() {
// 			const devToolsFrame = document.getElementById('devToolsFrame');
// 			const theme = document.body.classList.contains('vscode-light') ? 'light': 'dark';
// 			const background = currentBackgroundColor = getComputedStyle(document.documentElement).getPropertyValue('--vscode-sideBar-background');
// 			const foreground = getComputedStyle(document.documentElement).getPropertyValue('--vscode-sideBarTitle-foreground');
// 			const qsSep = currentBaseUrl.includes("?") ? "&" : "?";
// 			let url = \`\${currentBaseUrl}\${qsSep}${embedFlags}&theme=\${theme}&backgroundColor=\${encodeURIComponent(background)}&foregroundColor=\${encodeURIComponent(foreground)}\`;
// 			const fontSizeWithUnits = getComputedStyle(document.documentElement).getPropertyValue('--vscode-editor-font-size');
// 			if (fontSizeWithUnits && fontSizeWithUnits.endsWith('px')) {
// 				url += \`&fontSize=\${encodeURIComponent(parseFloat(fontSizeWithUnits))}\`;
// 			}
// 			if (devToolsFrame.src !== url)
// 				devToolsFrame.src = url;
// 		}

// 		const vscode = acquireVsCodeApi();
// 		window.addEventListener('message', (event) => {
// 			const devToolsFrame = document.getElementById('devToolsFrame');
// 			const message = event.data;

// 			// Handle any special commands first.
// 			switch (message.command) {
// 				case "_dart-code.setUrl":
// 					currentBaseUrl = message.url;
// 					setIframeSrc();
// 					return;
// 			}
// 		});

// 		document.addEventListener('DOMContentLoaded', function () {
// 			lastBackgroundColor = getComputedStyle(document.documentElement).getPropertyValue('--vscode-sideBar-background');
// 			new MutationObserver((mutationList) => {
// 				for (const mutation of mutationList) {
// 					if (mutation.type === "attributes" && mutation.attributeName == "class") {
// 						let newBackgroundColor = getComputedStyle(document.documentElement).getPropertyValue('--vscode-sideBar-background');
// 						if (newBackgroundColor !== currentBackgroundColor) {
// 							setIframeSrc();
// 						}
// 					}
// 				}
// 			}).observe(document.body, { attributeFilter : ['class'], attributeOldValue: true });
// 		});
// 		`;

//         webviewView.webview.options = {
//             enableScripts: true,
//             localResourceRoots: [],
//         };

//         webviewView.webview.html = `
// 			<html>
// 			<head>
// 			<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
// 			<script>${pageScript}</script>
// 			</head>
// 			<body><iframe id="devToolsFrame" src="about:blank" frameborder="0" allow="clipboard-read; clipboard-write; cross-origin-isolated" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%"></iframe></body>
// 			</html>
// 			`;

//         void webviewView.webview.postMessage({ command: "_dart-code.setUrl", url: sidebarUrl });
//     }

// }

