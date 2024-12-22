import 'package:flutter/material.dart';
import '../../../models/character.dart';
import 'initiative_input.dart';

class CharacterListItem extends StatelessWidget {
  final Character character;
  final TextEditingController controller;
  final VoidCallback onSort;
  final int index;
  final bool showTurnOrder;

  const CharacterListItem({
    super.key,
    required this.character,
    required this.controller,
    required this.onSort,
    required this.index,
    required this.showTurnOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            character.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              if (showTurnOrder)
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              InitiativeInput(
                character: character,
                controller: controller,
                onSort: onSort,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
