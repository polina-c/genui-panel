import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import '../../../shared/in_ide_message.dart';
import '../../../shared/primitives/ui/app_scaffold.dart';
import '../../../shared/primitives/ui/custom_icons.dart';
import '../../../shared/primitives/ui/genui_widget.dart';
import '../../../shared/primitives/post_message/post_message.dart';
import '../../../shared/primitives/post_message/primitives.dart';
import '../ui/_example_selector.dart';
import '../data/_prompt_examples.dart';
import '../ui/_prompt_input.dart';
import '../ui/_settings.dart';
import '../ui/_sign_in.dart';

void requestGenUi(SettingsController settings, {int? numberOfOptions}) {
  postMessageToAll(GenerateUiMessage(
    prompt: settings.prompt.text,
    numberOfOptions: numberOfOptions ?? settings.numberOfOptions,
    openOnSide: settings.openOnSide,
    uiSizePx: settings.uiSizePx,
  ).jsonEncode());
}
