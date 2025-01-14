import 'package:flutter/material.dart';

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({
    super.key,
    required this.height,
    required this.child,
    this.color = Colors.white,
    this.elevation = 4,
  });

  final double height;
  final Widget child;
  final Color? color;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: height,
          child: child,
        ),
      ),
    );
  }
}
