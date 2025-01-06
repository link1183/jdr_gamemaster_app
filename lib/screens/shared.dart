import 'package:flutter/material.dart';

class Shared {
  static Color getHealthColor(int current, int max) {
    final int percent = (current / max * 100).round();
    if (percent > 75) return const Color(0xFF43A047); // healthy
    if (percent > 50) return const Color(0xFFEF6C00); // injured
    if (percent > 25) return const Color(0xFFD32F2F); // bloodied
    return const Color(0xFF6A1B9A); // critical
  }

  static IconData getHealthIcon(int current, int max) {
    final int percent = (current / max * 100).round();
    if (percent > 75) return Icons.favorite;
    if (percent > 50) return Icons.heart_broken;
    if (percent > 25) return Icons.dangerous;
    return Icons.emergency;
  }
}
