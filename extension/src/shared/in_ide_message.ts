export class messageTypes {
    static readonly generateUi = 'generateUiMessage';
    static readonly revealPrompt = 'revealPromptMessage';
    static readonly revealUi = 'revealUiMessage';
    static readonly experimental = 'experimentalWindowMessage';
}

export function isMessageToSidebar(data: any): boolean {
    const type = data?.type;
    const result = type === messageTypes.experimental || type === messageTypes.generateUi;
    console.log(`!!!!!! node content, type: ${type}, isToSidebar: ${result}, prompt: ${data?.prompt}`);
    return result;
}
export class messageLocations {
    static readonly dart = 'dart';
    static readonly nodeSidebar = 'nodeSidebar';
    static readonly nodeContent = 'nodeContent';
}

export function parseMessageData(message: any): Object {
    let data = message?.data;
    if (typeof (data) === 'string') {
        console.log('!!!! parseMessageData: parsing data');
        data = JSON.parse(data);
        console.log('!!!! parseMessageData: parsed data');
    }
    console.log(`!!!! parsed data: ${JSON.stringify(data)}`);
    return data;
}

export function parseBoolean(value: any, defaultValue: boolean): boolean {
    if (value === undefined || value === null || value === '') {
        return defaultValue;
    }
    return value === 'true' || value === true || value === 1 || value === '1';
}
