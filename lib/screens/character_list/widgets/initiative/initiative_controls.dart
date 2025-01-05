import 'package:flutter/material.dart';
import '../../../../models/character.dart';
import 'initiative_input.dart';

class InitiativeControls extends StatelessWidget {
  final Character character;
  final TextEditingController controller;
  final VoidCallback onSort;
  final bool showTurnOrder;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final bool hasSameInitiativeAbove;
  final bool hasSameInitiativeBelow;
  final bool isMovingUp;
  final bool isMovingDown;

  const InitiativeControls({
    super.key,
    required this.character,
    required this.controller,
    required this.onSort,
    required this.showTurnOrder,
    this.onMoveUp,
    this.onMoveDown,
    required this.hasSameInitiativeAbove,
    required this.hasSameInitiativeBelow,
    required this.isMovingUp,
    required this.isMovingDown,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (showTurnOrder &&
              (hasSameInitiativeAbove || hasSameInitiativeBelow))
            Container(
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (hasSameInitiativeBelow)
                    _buildArrowButton(
                      Icons.keyboard_arrow_down,
                      onMoveDown,
                      isMovingDown,
                    ),
                  if (hasSameInitiativeAbove)
                    _buildArrowButton(
                      Icons.keyboard_arrow_up,
                      onMoveUp,
                      isMovingUp,
                    ),
                ],
              ),
            ),
          SizedBox(
            width: 84,
            child: InitiativeInput(
              character: character,
              controller: controller,
              onSort: onSort,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(
      IconData icon, VoidCallback? onPressed, bool isActive) {
    return IconButton(
      icon: Icon(
        icon,
        size: 20,
        color: isActive ? Colors.white : Colors.white70,
      ),
      onPressed: onPressed,
      hoverColor: Colors.white24,
      splashRadius: 14,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 16,
      ),
    );
  }
}
