import 'package:jdr_gamemaster_app/models/ability.dart';

class Creature {
  final int id;
  final String name;
  final int removedHitPoints;
  final int temporaryHitPoints;
  final int averageHitPoints;
  final int groupId;
  final int armorClass;
  final int passivePerception;
  final List<AbilityScore> _stats;
  late final AbilityScores stats;

  Creature({
    required this.id,
    required this.name,
    required this.removedHitPoints,
    required this.temporaryHitPoints,
    required this.averageHitPoints,
    required this.groupId,
    required this.armorClass,
    required this.passivePerception,
    required List<AbilityScore> stats,
  }) : _stats = stats {
    this.stats = AbilityScores(_stats, null);
  }

  int get currentHealth =>
      averageHitPoints - removedHitPoints + temporaryHitPoints;

  factory Creature.fromJson(Map<String, dynamic> json) {
    return Creature(
      id: json['id'] as int,
      name: json['name'] ?? json['definition']['name'] ?? '',
      removedHitPoints: json['removedHitPoints'] as int,
      temporaryHitPoints: json['temporaryHitPoints'] ?? 0,
      averageHitPoints: json['definition']['averageHitPoints'] as int,
      groupId: json['groupId'] as int,
      armorClass: json['definition']['armorClass'] as int,
      passivePerception: json['definition']['passivePerception'] as int,
      stats: (json['definition']['stats'] as List<dynamic>)
          .map<AbilityScore>(
              (dynamic x) => AbilityScore.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}
