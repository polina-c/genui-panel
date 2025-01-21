import 'package:flutter/material.dart';

import '../../../shared/primitives/ui/text_box_clear_button.dart';

class PromptInput extends StatelessWidget {
  const PromptInput(
    this.text, {
    required this.uiToAdjust,
    required this.focusNode,
  });
  final TextEditingController text;
  final String? uiToAdjust;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: text,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: uiToAdjust == null
            ? 'Describe UI you want to generate.'
            : 'Describe how you want to adjust "$uiToAdjust"',
        suffixIcon: clearButton(text),
      ),
      keyboardType: TextInputType.multiline,
      // Defines the min height:
      minLines: 5,
      // Defines the max height, before scrolling:
      maxLines: 12,
      autofocus: true,
    );
  }
}
