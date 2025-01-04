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
            ? Border.all(color: borderColor!.withValues(alpha: 0.3))
            : null,
      ),
      child: child,
    );
  }
}

class PassiveStatLabel extends StatelessWidget {
  final int value;
  final String label;

  const PassiveStatLabel({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class CurrencyLabel extends StatelessWidget {
  final int amount;
  final String symbol;
  final Color color;

  const CurrencyLabel({
    super.key,
    required this.amount,
    required this.symbol,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          amount.toString(),
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          symbol,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
