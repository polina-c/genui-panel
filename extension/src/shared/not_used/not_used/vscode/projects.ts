import * as path from "path";
import * as vs from "vscode";
import { Uri } from "vscode";
import { Logger } from "../../interfaces";
import { notUndefined } from "../../utils";
import { fsPath, homeRelativePath, isFlutterProjectFolder } from "../../utils/fs";
import { getAllProjectFolders } from "../../vscode/utils";

import { getExcludedFolders } from "../utils";

export async function getFolderToRunCommandIn(logger: Logger, placeHolder: string, selection?: vs.Uri, flutterOnly = false): Promise<string | undefined> {
	// Otherwise look for what projects we have.
	const selectableFolders = (await getAllProjectFolders(logger, getExcludedFolders, { requirePubspec: true, sort: true, searchDepth: 0 }))
		.filter(flutterOnly ? isFlutterProjectFolder : () => true);

	if (!selectableFolders || !selectableFolders.length) {
		const projectTypes = flutterOnly ? "Flutter" : "Dart/Flutter";
		void vs.window.showWarningMessage(`No ${projectTypes} project roots were found. Do you have a pubspec.yaml file?`);
		return undefined;
	}

	return showFolderPicker(selectableFolders, placeHolder); // TODO: What if the user didn't pick anything?
}

async function showFolderPicker(folders: string[], placeHolder: string): Promise<string | undefined> {
	// No point asking the user if there's only one.
	if (folders.length === 1) {
		return folders[0];
	}

	const items = folders.map((f) => {
		const workspaceFolder = vs.workspace.getWorkspaceFolder(Uri.file(f));
		if (!workspaceFolder)
			return undefined;

		const workspacePathParent = path.dirname(fsPath(workspaceFolder.uri));
		return {
			description: homeRelativePath(workspacePathParent),
			label: path.relative(workspacePathParent, f),
			path: f,
		} as vs.QuickPickItem & { path: string };
	}).filter(notUndefined);

	const selectedFolder = await vs.window.showQuickPick(items, { placeHolder });
	return selectedFolder && selectedFolder.path;
}
