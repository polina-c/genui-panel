import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.content});

  final WidgetBuilder content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: content(context));
  }
}
