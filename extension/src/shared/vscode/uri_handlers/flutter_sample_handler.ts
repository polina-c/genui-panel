import * as vs from "vscode";

export class FlutterSampleUriHandler {
	constructor(private flutterCapabilities: any) { }

	public handle(sampleID: string): void {
	}

	private readonly validSampleIdentifierPattern = new RegExp("^[\\w\\.]+$");
	private isValidSampleName(name: string): boolean {
		return this.validSampleIdentifierPattern.test(name);
	}
}
