import 'package:flutter/material.dart';

import '_gen_ui_card.dart';
import '_prompt_card.dart';

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
    final backgroundColor =
        Theme.of(context).colorScheme.primaryFixedDim.withAlpha(150);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(
              widget.prompt ??
                  'You did not describe what you want,'
                      ' so we will generate something nice for you.',
            ),
            const SizedBox(height: 20),
            const GenUiCard(),
          ],
        ),
      ),
    );
  }
}
