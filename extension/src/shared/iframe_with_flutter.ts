
//   <button onclick="messageToDart()">Message to Dart :)</ button>

import { messageFromTo } from "./in_ide_message";

export function htmlWithIFrame(url: string, iFrameType: string): string {
  const heightPx = 1200; // 100% does not work here, because of infinite vertical size of container.

  return `
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Security-Policy" content="default-src *; script-src 'unsafe-inline'; style-src 'unsafe-inline';">
	<script>${script(iFrameType)}</script>
</head>
<body>
  <iframe
    id="mainIFrame"
    src="${url}"
    width="100%"
    height="${heightPx}px"
    style="border: none;"
    allow="clipboard-read; clipboard-write; cross-origin-isolated">
  </iframe>
</body>
</html>
`;
}

function script(iFrameType: string): string {
  return `
const vscodeInJs = acquireVsCodeApi();

function messageToDart(message) {
  console.log('!!!!!! script: posting message to dart...');
  document.getElementById('mainIFrame').contentWindow.postMessage(message, '*');
  console.log('!!!!!! script: posting message to dart done.');
}

window.addEventListener('message', (event) => {
  console.log('!!!!!! script: got message', event);
  const message = {data: event.data, origin: event.origin};
  const fromTo = message.data?.fromTo;
  console.log('!!!!!! script: fromTo ', fromTo);

  if (fromTo === '${messageFromTo.fromContentToSidebar}' && '${iFrameType}' === 'sidebar') {
    messageToDart(JSON.stringify(message));
  } else {
    vscodeInJs.postMessage(message);
    console.log('!!!!!! script: posted message to node.');
  }
});
`;
}
