import 'package:flutter/material.dart';

import '../constants.dart';

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
      body: SingleChildScrollView(
          child: Column(
        children: [
          body,
          const SizedBox(height: 600),
          const Text(version),
        ],
      )),
      appBar: appBar,
      backgroundColor: backgroundColor,
    );
  }
}
