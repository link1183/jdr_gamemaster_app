import 'package:flutter/material.dart';
import '../../../../models/character.dart';
import '../initiative/initiative_controls.dart';

class CharacterHeader extends StatelessWidget {
  final Character character;
  final TextEditingController controller;
  final VoidCallback onSort;
  final bool showTurnOrder;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final bool hasSameInitiativeAbove;
  final bool hasSameInitiativeBelow;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final bool isMovingUp;
  final bool isMovingDown;

  const CharacterHeader({
    super.key,
    required this.character,
    required this.controller,
    required this.onSort,
    required this.showTurnOrder,
    this.onMoveUp,
    this.onMoveDown,
    required this.hasSameInitiativeAbove,
    required this.hasSameInitiativeBelow,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.isMovingUp,
    required this.isMovingDown,
  });

  Color _getHealthColor(int current, int max) {
    final int percent = (current / max * 100).round();
    if (percent > 75) return const Color(0xFF43A047); // healthy
    if (percent > 50) return const Color(0xFFEF6C00); // injured
    if (percent > 25) return const Color(0xFFD32F2F); // bloodied
    return const Color(0xFF6A1B9A); // critical
  }

  IconData _getHealthIcon(int current, int max) {
    final int percent = (current / max * 100).round();
    if (percent > 75) return Icons.favorite;
    if (percent > 50) return Icons.heart_broken;
    if (percent > 25) return Icons.dangerous;
    return Icons.emergency;
  }

  Widget _buildHealthDisplay() {
    final int current = character.currentHealth;
    final int max = character.maxHealth;
    final Color color = _getHealthColor(current, max);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'HP',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          _getHealthIcon(current, max),
          color: color,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '$current/$max',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggleExpanded,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: _buildHealthDisplay(),
              ),
              InitiativeControls(
                character: character,
                controller: controller,
                onSort: onSort,
                showTurnOrder: showTurnOrder,
                onMoveUp: onMoveUp,
                onMoveDown: onMoveDown,
                hasSameInitiativeAbove: hasSameInitiativeAbove,
                hasSameInitiativeBelow: hasSameInitiativeBelow,
                isMovingUp: isMovingUp,
                isMovingDown: isMovingDown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
