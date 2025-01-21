import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background of content.
  static Color softBg(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer;

  // Title font color in sidebar.
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  // Used for appBar background in sidebar.
  static Color accentBg(BuildContext context) =>
      Theme.of(context).colorScheme.inversePrimary;
}

class AppText {
  AppText._();

  static TextStyle sectionTitle(BuildContext context) =>
      TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary(context));
}
