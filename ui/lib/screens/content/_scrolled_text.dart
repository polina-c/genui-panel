import 'package:flutter/material.dart';

class ScrolledText extends StatelessWidget {
  ScrolledText(this.text, {super.key}) {
    content = text.split('\n');
  }
  final String text;
  late final List<String> content;
  final int maxLength = 650;

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
