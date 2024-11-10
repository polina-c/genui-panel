
export function htmlWithFlutterIFrame(flutterUrl: string): string {
  const heightPx = 1200; // 100% does not work here, because of infinite vertical size of container.

  return `
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
	<script>${everyScreenJsScript}</script>
</head>
<body>
  <button onclick="messageToDart()">Message to Dart :)</ button>
  <br/>
  <br/>
  <br/>
  <iframe
    id="sidebar"
    src="${flutterUrl}"
    width="100%"
    height="${heightPx}px"
    style="border: none;"
    allow="clipboard-read; clipboard-write; cross-origin-isolated">
  </iframe>
</body>
</html>
`;
}

export const everyScreenJsScript = `
const vscodeInJs = acquireVsCodeApi();

function messageToDart() {
  console.log('!!!!!! script: posting message to dart...');
  document.getElementById('sidebar').contentWindow.postMessage('hello from webview to dart', '*');
  console.log('!!!!!! script: posting message to dart done.');
}

window.addEventListener('message', (event) => {
  console.log('!!!!!! script: got message, posting to node', event);
  vscodeInJs.postMessage({data: event.data, origin: event.origin});
  console.log('!!!!!! script: posted message to node.');
});
`;
