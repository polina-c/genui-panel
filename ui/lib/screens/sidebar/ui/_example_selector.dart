import 'package:flutter/material.dart';

import '../data/_prompt_examples.dart';
import '_prompt_input.dart';

typedef ExampleSelectedCallback = void Function(PromptExample example);

class ExampleSelector extends StatelessWidget {
  ExampleSelector({super.key, required this.onSelection});

  final ExampleSelectedCallback onSelection;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: promptExamples.asMap().entries.map((e) {
        return TextButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: () => onSelection(e.value),
          child: Text(e.value.name),
        );
      }).toList(),
    );
  }
}
