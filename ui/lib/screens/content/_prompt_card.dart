import 'package:flutter/material.dart';

import '../../shared/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/ui/colors.dart';
import '../../shared/primitives/ui/horizontal_card.dart';
import '../../shared/primitives/ui/scrolled_text.dart';

class PromptCard extends StatelessWidget {
  const PromptCard(this.prompt, {super.key});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return HorizontalCard(
      elevation: 2,
      color: AppColors.softBg(context),
      height: 140,
      child: Stack(
        children: [
          ScrollableText(prompt.isEmpty
              ? 'You did not describe what you want,'
                  ' so generating something nice for you.'
              : prompt),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () => postMessageToAll(
                      EditPromptMessage(prompt: prompt).jsonEncode(),
                    ),
                child: const Text('Edit')),
          ),
        ],
      ),
    );
  }
}
