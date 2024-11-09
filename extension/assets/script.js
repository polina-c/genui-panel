const vscodeInJs = acquireVsCodeApi();

function messageToDart() {
    console.log('!!!!!! node sidebar: posting message to dart...');
    document.getElementById('sidebar').contentWindow.postMessage('hello from webview to dart', '*');
    console.log('!!!!!! node sidebar: posting message to dart done.');
}

window.addEventListener('message', (event) => {
    console.log('!!!!!! node sidebar: got message', event);
    let message = JSON.stringify(event.data);
    if (message.includes('(from webview)')) return;
    message = message + '(from webview)';
    let origin = event.origin;
    console.log('!!!!!! node sidebar: posting message to dart...', message, origin);
    vscodeInJs.postMessage(message);
    console.log('!!!!!! node sidebar: posted to vscodeInJs');
    window.postMessage(message);
    console.log('!!!!!! node sidebar: posted message to dart.', message, origin);
});
