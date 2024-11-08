import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final WidgetBuilder content;
  const AppScaffold({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: content(context));
  }
}
