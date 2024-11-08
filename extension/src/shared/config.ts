
export class Config {
    static isIdx: boolean = !!process.env.MONOSPACE_ENV;
    static isLocal: boolean = true;

    public static get uiUrl(): string {
        return Config.isLocal ? "https://genui-panel.web.app" : "http://localhost:8080";
    }

    public static get sidebarUrl(): string {
        return Config.uiUrl + "/#/sidebar";
    }

    public static get contentUrl(): string {
        return Config.uiUrl + "/#/content";
    }
}
