import 'package:flutter/material.dart';

import '../../shared/primitives/horizontal_card.dart';
import '../../shared/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/scrolled_text.dart';

class PromptCard extends StatelessWidget {
  const PromptCard(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return HorizontalCard(
      height: 140,
      child: Stack(
        children: [
          ScrollableText(text),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () => postMessageToAll(
                      RevealPromptMessage(text).jsonEncode(),
                    ),
                child: const Text('Reveal')),
          ),
        ],
      ),
    );
  }
}
