
//   <button onclick="messageToDart()">Message to Dart :)</ button>

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
  <iframe
    id="flutterIFrame"
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

function messageToDart(message) {
  console.log('!!!!!! script: posting message to dart...');
  document.getElementById('flutterIFrame').contentWindow.postMessage(message, '*');
  console.log('!!!!!! script: posting message to dart done.');
}

window.addEventListener('message', (event) => {
  console.log('!!!!!! script: got message', event);
  const message = {data: event.data, origin: event.origin};

  console.log('!!!!!! script: 1');

  const to = message.data?.to;

  console.log('!!!!!! script: to ', to);

  if (to === 'dart') {
    messageToDart(JSON.stringify(message));
    console.log('!!!!!! script: posted message to dart.');
  }

  vscodeInJs.postMessage(message);
  console.log('!!!!!! script: posted message to node.');
});
`;
