
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
  if (message.includes('(from webview)')) return;
  message = message + '(from webview)';
  let origin = event.origin;
  console.log('!!!!!! script: posting message to dart...', message, origin);
  vscodeInJs.postMessage(message);
  console.log('!!!!!! script: posted to vscodeInJs');
  window.postMessage(message);
  console.log('!!!!!! script: posted message to dart.', message, origin);
});
`;
