import * as vscode from "vscode";
import { showContentPanel } from "./content";
import { Config } from "../shared/config";
import { htmlWithIFrame } from "../shared/iframe_with_flutter";
import { messageLocations, messageTypes, parseBoolean, parseMessageData } from "../shared/in_ide_message";
import { showExperimentalPanel } from "./experimental";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.view";

  constructor(private readonly extentionContext: vscode.ExtensionContext) { }

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext<unknown>,
    token: vscode.CancellationToken
  ): void | Thenable<void> {
    const view = webviewView.webview;

    view.options = {
      enableScripts: true,
      enableCommandUris: true,
    };
    view.html = htmlWithIFrame(Config.sidebarUrl);

    view.onDidReceiveMessage(
      (message) => {
        console.log(`!!!!!! node sidebar, got message, ${typeof (message)}, ${message}`);
        const data: any = parseMessageData(message);
        const type = data?.type;

        const prompt = data?.prompt;
        const numberOfOptions = data?.numberOfOptions ?? 1;
        const openOnSide = parseBoolean(data?.openOnSide, false);
        const uiSizePx = data?.uiSizePx;

        if (type === messageTypes.experimental) {
          console.log(`!!!!!! node sidebar, opening experimental page`);
          showExperimentalPanel();
          return;
        }

        if (type !== messageTypes.generateUi) {
          return;
        }

        showContentPanel(
          prompt,
          numberOfOptions,
          openOnSide,
          uiSizePx,
          this.extentionContext.extensionUri,
          // What to do when the user selects wants to reveal the prompt in the sidebar.
          () => view.postMessage(
            {
              type: messageTypes.revealPrompt,
              to: messageLocations.dart,
              prompt: data?.prompt,
            }
          ),
        );

      },
    );
  }
}
