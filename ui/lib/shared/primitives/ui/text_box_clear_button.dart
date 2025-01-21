import 'package:flutter/material.dart';

import 'colors.dart';

/// Generated the button 'clear' for a `TextField`.
///
/// Assign the result to the property `suffix` of a `TextField`
/// to add a clear button.
Widget clearButton(TextEditingController text) {
  return ValueListenableBuilder(
      valueListenable: text,
      builder: (context, value, child) {
        if (text.value.text.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox.shrink(
          child: IconButton(
            onPressed: text.clear,
            icon: const Icon(Icons.clear),
            color: AppColors.primary(context),
            iconSize: 16,
          ),
        );
      });
}
