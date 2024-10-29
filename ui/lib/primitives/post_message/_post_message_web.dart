// Copyright 2024 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.

import 'dart:js_interop';

import 'package:web/web.dart';

import 'post_message.dart';

Stream<PostMessageEvent> get onPostMessage {
  return window.onMessage.map(
    (message) => PostMessageEvent(
      origin: message.origin,
      data: message.data.dartify(),
    ),
  );
}

void postMessage(Object? message, String targetOrigin) {
  print('!!!! hello from postMessage');
  window.parentCrossOrigin?.postMessage(message.jsify(), targetOrigin.toJS);
  print('!!!! hello from postMessage, done');
}
