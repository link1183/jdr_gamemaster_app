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
    return SizedBox(
      width: 100,
      child: Focus(
        child: TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Initiative',
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.white38, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.white38, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
      ),
    );
  }
}
