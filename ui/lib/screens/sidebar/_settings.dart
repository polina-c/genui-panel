import 'package:flutter/material.dart';

import '../../shared/primitives/constants.dart';

class SettingsController {
  int _numberOfOptions = 1;
  int get numberOfOptions => _numberOfOptions;

  bool _openOnSide = false;
  bool get openOnSide => _openOnSide;

  /// No-op placeholder.
  void dispose() {}
}

class SettingsExpandableButton extends StatefulWidget {
  const SettingsExpandableButton(
    this.controller, {
    super.key,
  });

  final SettingsController controller;

  @override
  State<SettingsExpandableButton> createState() =>
      _SettingsExpandableButtonState();
}

class _SettingsExpandableButtonState extends State<SettingsExpandableButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.settings),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            label:
                Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ),
          if (_isExpanded) ...[
            const SizedBox(width: 8),
            Row(
              children: [
                Checkbox(
                  value: widget.controller.openOnSide,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.controller._openOnSide = newValue ?? false;
                    });
                  },
                ),
                const Text(
                  'Open the generated UI to the side of the active editor.',
                ),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                const Text('Number of options to generate: '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  isDense: true,
                  focusColor: Colors.white,
                  value: widget.controller.numberOfOptions,
                  onChanged: (int? newValue) {
                    setState(
                      () => widget.controller._numberOfOptions = newValue ?? 1,
                    );
                  },
                  items: List.generate(maxNumberOfGeneratedOptions, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    );
                  }),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
