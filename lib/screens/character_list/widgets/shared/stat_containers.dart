import 'package:flutter/material.dart';

class StatContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;
  final double height;
  final EdgeInsets padding;

  const StatContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor,
    this.height = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null
            ? Border.all(
                color: borderColor!.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: child,
    );
  }
}
