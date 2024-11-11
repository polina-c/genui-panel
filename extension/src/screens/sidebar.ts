import * as vscode from "vscode";
import { showContentPanel } from "./content";
import { Config } from "../shared/config";
import { htmlWithFlutterIFrame } from "../shared/iframe_with_flutter";
import { messageLocations, messageTypes, parseBoolean, parseMessageData } from "../shared/in_ide_message";

export class SidebarProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = "genui-panel.openview";

  constructor() { }

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
    view.html = htmlWithFlutterIFrame(Config.sidebarUrl);

    view.onDidReceiveMessage(
      (message) => {
        console.log(`!!!!!! node sidebar, got message, ${typeof (message)}, ${message}`);
        const data: any = parseMessageData(message);
        const type = data?.type;

        const prompt = data?.prompt;
        const numberOfOptions = data?.numberOfOptions ?? 1;

        const sideBySide = parseBoolean(data?.sideBySide, false);
        console.log(`!!!!!! node sidebar, sideBySide parsed from ${data?.sideBySide} to ${sideBySide}`);
        console.log(`!!!!!! node sidebar, type: ${type}, numberOfOptions: ${numberOfOptions}, sideBySide: ${sideBySide}, prompt: ${prompt}`);

        if (type !== messageTypes.generateUi) {
          return;
        }

        showContentPanel(
          prompt,
          numberOfOptions,
          sideBySide,
          // What to do when the user selects wants to reveal the prompt in the sidebar.
          () => view.postMessage(
            {
              type: messageTypes.reveal,
              to: messageLocations.dart,
              prompt: data?.prompt,
            }
          ),
        );

      },
    );
  }
}
