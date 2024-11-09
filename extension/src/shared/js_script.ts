
export const everyScreenJsScript = `
const vscodeInJs = acquireVsCodeApi();

function messageToDart() {
  console.log('!!!!!! script: posting message to dart...');
  document.getElementById('sidebar').contentWindow.postMessage('hello from webview to dart', '*');
  console.log('!!!!!! script: posting message to dart done.');
}

window.addEventListener('message', (event) => {
  console.log('!!!!!! script: got message', event);
  vscodeInJs.postMessage(JSON.stringify({data: event.data, origin: event.origin}));
  console.log('!!!!!! script: posted message to node.');
});
`;
