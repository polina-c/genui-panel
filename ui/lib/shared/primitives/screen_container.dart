import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
  });

  final Widget body;
  final AppBar? appBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: body),
      appBar: appBar,
      backgroundColor: backgroundColor,
    );
  }
}
