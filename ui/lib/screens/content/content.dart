import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/primitives/horizontal_card.dart';
import '../../shared/primitives/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';

import '_genUiCard.dart';
import '../../shared/primitives/scrolled_text.dart';
import '_promptCard.dart';

class ContentScreen extends StatefulWidget {
  ContentScreen({super.key, String? prompt}) {
    if (prompt == '') {
      prompt = null;
    }
    // ignore: prefer_initializing_formals, false positive
    this.prompt = prompt;
  }

  late final String? prompt;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.primaryFixedDim;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(widget.prompt ?? '<No prompt>'),
            const SizedBox(height: 20),
            const GenUiCard(),
          ],
        ),
      ),
    );
  }
}
