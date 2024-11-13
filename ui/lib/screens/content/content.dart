import 'package:flutter/material.dart';

import '../../shared/primitives/app_scaffold.dart';
import '../../shared/primitives/constants.dart';
import '_gen_ui_card.dart';
import '_prompt_card.dart';

class ContentScreen extends StatefulWidget {
  ContentScreen({
    super.key,
    required this.prompt,
    required int numberOfOptions,
    required int uiSizePx,
    required this.panelName,
  })  : numberOfOptions = numberOfOptions.clamp(1, maxNumberOfGeneratedOptions),
        uiSizePx = uiSizePx.clamp(minUiSizePx, maxUiSizePx);

  final int uiSizePx;
  final String prompt;
  final int numberOfOptions;
  final String panelName;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        Theme.of(context).colorScheme.primaryFixedDim.withAlpha(150);

    final List<GenUiCard> cards;
    if (widget.numberOfOptions == 1) {
      cards = [
        GenUiCard(uiSizePx: widget.uiSizePx, panelName: widget.panelName)
      ];
    } else {
      // ignore: inference_failure_on_instance_creation
      cards = Iterable<int>.generate(widget.numberOfOptions)
          .map(
            (int index) => GenUiCard(
              uiSizePx: widget.uiSizePx,
              panelName: widget.panelName,
              index: index + 1,
            ),
          )
          .toList();
    }

    return AppScaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(widget.prompt),
            const SizedBox(height: 20),
            ...cards,
          ],
        ),
      ),
    );
  }
}
