import 'package:flutter/material.dart';

import '../../shared/in_ide_message.dart';
import '../../shared/primitives/horizontal_card.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/scrolled_text.dart';

class PromptCard extends StatelessWidget {
  const PromptCard(this.prompt, {super.key});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return HorizontalCard(
      height: 140,
      child: Stack(
        children: [
          ScrollableText(prompt.isEmpty
              ? 'You did not describe what you want,'
                  ' so we will generate something nice for you.'
              : prompt),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () => postMessageToAll(
                      RevealPromptMessage(prompt: prompt).jsonEncode(),
                    ),
                child: const Text('Reveal')),
          ),
        ],
      ),
    );
  }
}
