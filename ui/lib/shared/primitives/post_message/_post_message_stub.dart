// Copyright 2024 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.

import 'primitives.dart';

Stream<PostMessageEvent> get onPostMessage =>
    throw UnsupportedError('unsupported platform');

void postMessage(Object? _, String __) =>
    throw UnsupportedError('unsupported platform');
