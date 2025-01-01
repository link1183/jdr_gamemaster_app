import 'package:flutter/material.dart';
import '../../../models/character.dart';
import 'initiative_input.dart';

class CharacterListItem extends StatelessWidget {
  final Character character;
  final TextEditingController controller;
  final VoidCallback onSort;
  final int index;
  final bool showTurnOrder;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final bool hasSameInitiativeAbove;
  final bool hasSameInitiativeBelow;

  const CharacterListItem({
    super.key,
    required this.character,
    required this.controller,
    required this.onSort,
    required this.index,
    required this.showTurnOrder,
    this.onMoveUp,
    this.onMoveDown,
    required this.hasSameInitiativeAbove,
    required this.hasSameInitiativeBelow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 56, // Increased height for better touch targets
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.9),
            theme.colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                width: 4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side with rank and name
              Expanded(
                child: Row(
                  children: [
                    if (showTurnOrder)
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      character.name,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Right side with arrows and initiative
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showTurnOrder &&
                      (hasSameInitiativeAbove || hasSameInitiativeBelow))
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasSameInitiativeAbove)
                            IconButton(
                              icon:
                                  const Icon(Icons.keyboard_arrow_up, size: 20),
                              onPressed: onMoveUp,
                              color: theme.colorScheme.onPrimary
                                  .withValues(alpha: 0.7),
                              hoverColor: theme.colorScheme.onPrimary
                                  .withValues(alpha: 0.2),
                              splashRadius: 14,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 20,
                              ),
                            )
                          else
                            const SizedBox(height: 20),
                          if (hasSameInitiativeBelow)
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              onPressed: onMoveDown,
                              color: theme.colorScheme.onPrimary
                                  .withValues(alpha: 0.7),
                              hoverColor: theme.colorScheme.onPrimary
                                  .withValues(alpha: 0.2),
                              splashRadius: 14,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 20,
                              ),
                            )
                          else
                            const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: 80,
                    child: InitiativeInput(
                      character: character,
                      controller: controller,
                      onSort: onSort,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
