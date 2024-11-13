import 'package:flutter/material.dart';

typedef AppCheckboxOnChangedCallback = void Function(bool newValue);

class AppCheckbox extends StatelessWidget {
  const AppCheckbox(
      {super.key, this.onChanged, required this.value, required this.label});

  final AppCheckboxOnChangedCallback? onChanged;
  final bool value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged == null
              ? null
              : (bool? newValue) => onChanged!(newValue ?? false),
        ),
        Text(label),
      ],
    );
  }
}
