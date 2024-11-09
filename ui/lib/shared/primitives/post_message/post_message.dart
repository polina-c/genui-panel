import '_post_message_stub.dart'
    if (dart.library.js_interop) '_post_message_web.dart';
import 'primitives.dart';

void postMessageToAll(String data) {
  postMessage(data, '*');
}

Stream<PostMessageEvent> get onMessagePosted => onPostMessage;
