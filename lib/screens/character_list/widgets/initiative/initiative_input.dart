import 'package:flutter/material.dart';
import '../../../../models/character.dart';

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
    final ThemeData theme = Theme.of(context);
    return Focus(
      onFocusChange: (bool hasFocus) {
        if (!hasFocus) onSort();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Initiative',
            hintStyle: TextStyle(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            filled: true,
            fillColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 0,
            ),
          ),
          onChanged: (String value) {
            if (value.isEmpty) {
              character.initiative = null;
            } else {
              final int? initiative = int.tryParse(value);
              if (initiative != null) {
                character.initiative = initiative;
              }
            }
          },
          onSubmitted: (String _) => onSort(),
          controller: controller,
        ),
      ),
    );
  }
}
