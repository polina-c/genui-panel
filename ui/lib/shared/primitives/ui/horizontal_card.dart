import 'package:flutter/material.dart';

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({
    super.key,
    required this.height,
    required this.child,
    this.color = Colors.white,
    this.elevation = 4,
    this.borderColor,
  });

  final double height;
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor!, width: 0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
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
