import 'package:flutter/material.dart';

class ScrolledText extends StatelessWidget {
  ScrolledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Text(
          text,
          softWrap: false,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
