import 'package:flutter/material.dart';
import 'package:jdr_gamemaster_app/screens/shared.dart';
import '../../../../models/creature.dart';

class CharacterCreatures extends StatelessWidget {
  final List<Creature> creatures;
  final Creature? activeTransformation;
  final Function(Creature?) onTransformationChanged;

  const CharacterCreatures({
    super.key,
    required this.creatures,
    required this.activeTransformation,
    required this.onTransformationChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (creatures.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Créatures',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: creatures
                .map<Widget>(
                    (Creature creature) => _buildCreatureCard(creature))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatureCard(Creature creature) {
    final Color color = Shared.getHealthColor(
        creature.currentHealth, creature.averageHitPoints);
    final bool isTransformed = activeTransformation?.id == creature.id;

    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            onTransformationChanged(isTransformed ? null : creature);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isTransformed ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                      value: isTransformed,
                      onChanged: (bool? value) {
                        onTransformationChanged(
                            value == true ? creature : null);
                      },
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return color;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    Icon(
                      Shared.getHealthIcon(
                          creature.currentHealth, creature.averageHitPoints),
                      color: color,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      creature.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildCreatureStat(
                      'HP',
                      '${creature.currentHealth}/${creature.averageHitPoints}',
                      color,
                    ),
                    const SizedBox(width: 8),
                    _buildCreatureStat(
                      'CA',
                      creature.armorClass.toString(),
                      Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Perception passive',
                      child: _buildCreatureStat(
                        'PP',
                        creature.passivePerception.toString(),
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildCreatureStat(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
