
export class Config {
    static isIdx: boolean = !!process.env.MONOSPACE_ENV;
    static isLocal: boolean = false;

    public static get uiUrl(): string {
        return Config.isLocal ? "http://localhost:8080" : "https://genui-panel.web.app";
    }

    public static get sidebarUrl(): string {
        return Config.uiUrl + "/#/sidebar";
    }

    public static contentUrl(prompt: string, numberOfOptions: number, uiSizePx: number | undefined, panelName: string): string {
        return `${Config.uiUrl}/#/content?prompt=${encodeURI(prompt)}&numberOfOptions=${numberOfOptions}&uiSizePx=${uiSizePx}&panelName=${panelName}`;
    }
}
