import 'package:flutter/material.dart';
import '../../../models/character.dart';

class InitiativeInput extends StatelessWidget {
  final Character character;
  final TextEditingController controller;
  final VoidCallback onSort;

  const InitiativeInput({
    super.key,
    required this.character,
    required this.controller,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          onSort();
        }
      },
      child: TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Initiative',
          hintStyle: TextStyle(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 0,
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            character.initiative = null;
          } else {
            final initiative = int.tryParse(value);
            if (initiative != null) {
              character.initiative = initiative;
            }
          }
        },
        onSubmitted: (_) => onSort(),
        controller: controller,
      ),
    );
  }
}
