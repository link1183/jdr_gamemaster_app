import 'package:flutter/material.dart';
import '../../../../models/character.dart';
import '../shared/stat_containers.dart';

class CharacterStats extends StatelessWidget {
  final Character character;

  const CharacterStats({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildPassiveStat(character.passivePerception, 'PERCEPTION'),
          const SizedBox(width: 8),
          _buildPassiveStat(character.passiveInvestigation, 'INVESTIGATION'),
          const SizedBox(width: 8),
          _buildPassiveStat(character.passiveInsight, 'INSIGHT'),
        ],
      ),
    );
  }

  Widget _buildPassiveStat(int value, String label) {
    return Tooltip(
      message: _getPassiveDescription(label, value),
      child: StatContainer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
        ),
      ),
    );
  }

  String _getPassiveDescription(String type, int value) {
    switch (type) {
      case 'PERCEPTION':
        return 'Perception passive: $value\nUtilisé pour repérer automatiquement les choses cachées';
      case 'INVESTIGATION':
        return 'Investigation passive: $value\nUtilisé pour remarquer automatiquement les indices et anomalies';
      case 'INSIGHT':
        return 'Intuition passive: $value\nUtilisé pour détecter automatiquement les mensonges et intentions';
      default:
        return '$type: $value';
    }
  }
}
