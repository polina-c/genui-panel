
export const everyScreenJsScript = `
const vscodeInJs = acquireVsCodeApi();

function messageToDart() {
  console.log('!!!!!! script: posting message to dart...');
  document.getElementById('sidebar').contentWindow.postMessage('hello from webview to dart', '*');
  console.log('!!!!!! script: posting message to dart done.');
}

window.addEventListener('message', (event) => {
  console.log('!!!!!! script: got message', event);
  let message = JSON.stringify(event.data);
  let origin = event.origin;
  console.log('!!!!!! script: posting message to node...', message, origin);
  vscodeInJs.postMessage(message);
});
`;
