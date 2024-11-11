import 'package:flutter/material.dart';

import '../../shared/primitives/constants.dart';
import '../../shared/primitives/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';

class SettingsController {
  int _numberOfOptions = 1;
  int get numberOfOptions => _numberOfOptions;

  bool _openOnSide = false;
  bool get openOnSide => _openOnSide;

  int _uiSizePx = defaultUiSizePx;
  int get uiSizePx => _uiSizePx;

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
  final _sizeController = TextEditingController();

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sizeController.text = widget.controller.uiSizePx.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                'Open the generated UI to the side.',
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
          const SizedBox(width: 8),
          Row(
            children: [
              const Text('UI size in pixels: '),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextField(
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  controller: _sizeController,
                  onChanged: (String value) {
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null) return;
                    if (parsedValue <= 0) return;
                    if (parsedValue > 1000) return;
                    setState(() {
                      widget.controller._uiSizePx = parsedValue;
                    });
                  },
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              postMessageToAll(ExperimentalWindowMessage().jsonEncode());
            },
            child: const Text('Open experimental window'),
          ),
        ]
      ],
    );
  }
}
