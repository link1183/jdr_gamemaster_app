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
        children: [
          StatContainer(
            child: PassiveStatLabel(
              value: character.passivePerception,
              label: 'PERCEPTION',
            ),
          ),
          const SizedBox(width: 8),
          StatContainer(
            child: PassiveStatLabel(
              value: character.passiveInvestigation,
              label: 'INVESTIGATION',
            ),
          ),
          const SizedBox(width: 8),
          StatContainer(
            child: PassiveStatLabel(
              value: character.passiveInsight,
              label: 'INSIGHT',
            ),
          ),
        ],
      ),
    );
  }
}
