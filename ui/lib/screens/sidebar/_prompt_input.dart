import 'package:flutter/material.dart';

import '_prompt_examples.dart';

class PromptInput extends StatelessWidget {
  const PromptInput(this.text, {required this.uiToAdjust});
  final TextEditingController text;
  final String? uiToAdjust;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        TextField(
          controller: text,
          decoration: InputDecoration(
            hintText: uiToAdjust == null
                ? 'Describe UI you want to generate.'
                : 'Describe how you want to adjust "$uiToAdjust"',
          ),
          keyboardType: TextInputType.multiline,
          // Defines the min height:
          minLines: 5,
          // Defines the max height, before scrolling:
          maxLines: 20,
          autofocus: true,
        ),
        Positioned(
          top: 0,
          child: ValueListenableBuilder(
              valueListenable: text,
              builder: (context, value, child) {
                if (text.value.text.isEmpty) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  onPressed: text.clear,
                  icon: const Icon(Icons.clear),
                  iconSize: 16,
                );
              }),
        ),
      ],
    );
  }
}
