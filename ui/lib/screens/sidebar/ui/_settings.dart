import 'package:flutter/material.dart';

import '../../../shared/in_ide_message.dart';
import '../../../shared/primitives/ui/app_checkbox.dart';
import '../../../shared/primitives/constants.dart';
import '../../../shared/primitives/post_message/post_message.dart';
import '../data/_generate.dart';

class SettingsController {
  int numberOfOptions = 1;

  bool openOnSide = false;

  int uiSizePx = defaultUiSizePx;

  bool useAppTheme = false;

  bool useAppWidgets = false;

  final TextEditingController prompt = TextEditingController();

  /// No-op placeholder.
  void dispose() {
    prompt.dispose();
  }
}

class GenerateBtnWithSettings extends StatefulWidget {
  const GenerateBtnWithSettings(
    this.controller, {
    super.key,
  });

  final SettingsController controller;

  @override
  State<GenerateBtnWithSettings> createState() =>
      _GenerateBtnWithSettingsState();
}

class _GenerateBtnWithSettingsState extends State<GenerateBtnWithSettings> {
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
    const verticalSpace = SizedBox(height: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NumberOfOptions(controller: widget.controller),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.settings),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              label: Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ),
            _GenerateBtn(settings: widget.controller),
          ],
        ),
        if (_isExpanded) ...[
          verticalSpace,
          AppCheckbox(
            onChanged: (bool newValue) =>
                setState(() => widget.controller.openOnSide = newValue),
            value: widget.controller.openOnSide,
            label: 'Open the generated UI to the side.',
          ),
          verticalSpace,
          verticalSpace,
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
                      widget.controller.uiSizePx = parsedValue;
                    });
                  },
                ),
              ),
            ],
          ),
          verticalSpace,
          AppCheckbox(
            onChanged: (bool newValue) =>
                setState(() => widget.controller.useAppTheme = newValue),
            value: widget.controller.useAppTheme,
            label: 'Use theme of my application.',
          ),
          verticalSpace,
          AppCheckbox(
            onChanged: (bool newValue) =>
                setState(() => widget.controller.useAppWidgets = newValue),
            value: widget.controller.useAppWidgets,
            label: 'Use widgets of my application.',
          ),
          const SizedBox(height: 40),
          const Text('(Please, ignore artifacts below:)'),
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

class NumberOfOptions extends StatefulWidget {
  const NumberOfOptions({required this.controller});

  final SettingsController controller;

  @override
  State<NumberOfOptions> createState() => NumberOfOptionsState();
}

class NumberOfOptionsState extends State<NumberOfOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Number of options to generate: '),
        const SizedBox(width: 8),
        DropdownButton<int>(
          isDense: true,
          focusColor: Colors.white,
          value: widget.controller.numberOfOptions,
          onChanged: (int? newValue) {
            setState(() {
              widget.controller.numberOfOptions = newValue ?? 1;
            });
          },
          items: List.generate(maxNumberOfGeneratedOptions, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text('${index + 1}'),
            );
          }),
        ),
      ],
    );
  }
}

class _GenerateBtn extends StatelessWidget {
  const _GenerateBtn({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => requestGenUi(settings),
      child: const Text('Generate UI'),
      style: ButtonStyle(elevation: WidgetStateProperty.all(4)),
    );
  }
}
