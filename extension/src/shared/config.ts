
export class Config {
    static isIdx: boolean = !!process.env.MONOSPACE_ENV;
    static isLocal: boolean = true;

    public static get uiUrl(): string {
        return Config.isLocal ? "http://localhost:8080" : "https://genui-panel.web.app";
    }

    public static get sidebarUrl(): string {
        return Config.uiUrl + "/#/sidebar";
    }

    public static contentUrl(prompt: string): string {
        return Config.uiUrl + "/#/content?prompt=" + encodeURI(prompt);
    }
}
