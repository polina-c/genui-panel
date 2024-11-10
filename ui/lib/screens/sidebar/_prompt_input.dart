import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_prompt_examples.dart';

class PromptInput extends StatelessWidget {
  const PromptInput(this.text);
  final TextEditingController text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        TextField(
          controller: text,
          decoration: const InputDecoration(
            hintText: 'Describe UI you want to generate.',
          ),
          keyboardType: TextInputType.multiline,
          // Defines the min height:
          minLines: 5,
          // Defines the max height, before scrolling:
          maxLines: 20,
          autofocus: true,
        ),
        _ExampleDropdown((example) {
          text.text = example.prompt;
        }),
      ],
    );
  }
}

typedef ExampleSelectedCallback = void Function(PromptExample example);

class _ExampleDropdown extends StatelessWidget {
  const _ExampleDropdown(this.onSelection);

  final ExampleSelectedCallback onSelection;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Select example',
      icon: const Icon(Icons.arrow_drop_down_circle),
      iconColor: Theme.of(context).colorScheme.primary,
      itemBuilder: (BuildContext context) {
        return promptExamples.asMap().entries.map((e) {
          return PopupMenuItem<int>(
            value: e.key,
            child: Text(e.value.name),
            onTap: () => onSelection(e.value),
          );
        }).toList();
      },
    );
  }
}
