export class messageTypes {
    static readonly generateUi = 'generateUi';
    static readonly reveal = 'reveal';
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
    return data;
}

