import 'package:jdr_gamemaster_app/models/classes.dart';
import 'package:jdr_gamemaster_app/models/inventory.dart';
import 'package:jdr_gamemaster_app/models/modifier.dart';
import 'package:jdr_gamemaster_app/models/ability.dart';

typedef JsonObject = Map<String, dynamic>;

class Character {
  final int id;
  final String name;
  final int baseHitPoints;
  final int removedHitPoints;
  final int temporaryHitPoints;
  final List<AbilityScore> _stats;
  final List<InventoryItem> inventory;
  final List<Class> classes;
  final Modifier modifiers;
  final List<JsonObject> customDefenseAdjustments;
  late final AbilityScores stats;
  int? initiative;
  int tiebreaker = 0;

  Character({
    required this.id,
    required this.name,
    required this.baseHitPoints,
    required this.removedHitPoints,
    required this.temporaryHitPoints,
    required List<AbilityScore> stats,
    required this.inventory,
    required this.classes,
    required this.modifiers,
    required this.customDefenseAdjustments,
    this.initiative,
    this.tiebreaker = 0,
  }) : _stats = stats {
    this.stats = AbilityScores(_stats, this);
  }

  int get maxHealth =>
      baseHitPoints + stats.getModifier(stats.constitution) * level;

  int get currentHealth => maxHealth + temporaryHitPoints - removedHitPoints;

  int get level =>
      classes.fold(0, (sum, characterClass) => sum + characterClass.level);

  factory Character.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    return Character(
      id: json['id'],
      name: json['name'] as String,
      baseHitPoints: json['baseHitPoints'] as int,
      removedHitPoints: json['removedHitPoints'] as int,
      temporaryHitPoints: json['temporaryHitPoints'] as int,
      stats: (json['stats'] as List<dynamic>)
          .map((x) => AbilityScore.fromJson(x as Map<String, dynamic>))
          .toList(),
      inventory: (json['inventory'] as List<dynamic>)
          .map((x) => InventoryItem.fromJson(x as Map<String, dynamic>))
          .toList(),
      classes: (json['classes'] as List<dynamic>)
          .map((x) => Class.fromJson(x))
          .toList(),
      modifiers: Modifier.fromJson(json['modifiers']),
      customDefenseAdjustments:
          (json['customDefenseAdjustments'] as List<dynamic>)
              .map((x) => x as Map<String, dynamic>)
              .toList(),
      initiative: null,
      tiebreaker: 0,
    );
  }
}
