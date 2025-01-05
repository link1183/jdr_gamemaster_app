import 'package:jdr_gamemaster_app/models/classes.dart';
import 'package:jdr_gamemaster_app/models/creature.dart';
import 'package:jdr_gamemaster_app/models/currency.dart';
import 'package:jdr_gamemaster_app/models/enums.dart';
import 'package:jdr_gamemaster_app/models/inventory.dart';
import 'package:jdr_gamemaster_app/models/modifier.dart';
import 'package:jdr_gamemaster_app/models/ability.dart';

typedef JsonObject = Map<String, dynamic>;

class Character {
  int id;
  final String name;
  final int _baseHitPoints;
  final int _removedHitPoints;
  final int _temporaryHitPoints;
  final List<AbilityScore> _stats;
  final List<InventoryItem> inventory;
  final List<Class> classes;
  final Modifier modifiers;
  final List<JsonObject> customDefenseAdjustments;
  late final AbilityScores stats;
  final Currency currency;
  final List<Creature> creatures;
  int? initiative;
  int tiebreaker = 0;
  Creature? _activeTransformation;

  Character({
    required this.id,
    required this.name,
    required int baseHitPoints,
    required int removedHitPoints,
    required int temporaryHitPoints,
    required List<AbilityScore> stats,
    required this.inventory,
    required this.classes,
    required this.modifiers,
    required this.customDefenseAdjustments,
    required this.currency,
    required this.creatures,
    this.initiative,
    this.tiebreaker = 0,
  })  : _temporaryHitPoints = temporaryHitPoints,
        _removedHitPoints = removedHitPoints,
        _baseHitPoints = baseHitPoints,
        _stats = stats {
    this.stats = AbilityScores(_stats, this);
  }

  Creature? get activeTransformation => _activeTransformation;

  void transform(Creature? creature) {
    _activeTransformation = creature;
  }

  int get maxHealth =>
      _activeTransformation?.averageHitPoints ??
      (_baseHitPoints + stats.constitution.modifier * level);

  int get currentHealth =>
      _activeTransformation?.currentHealth ??
      (maxHealth + _temporaryHitPoints - _removedHitPoints);

  int get level =>
      classes.fold(0, (sum, characterClass) => sum + characterClass.level);

  int get proficiencyBonus {
    if (level <= 4) {
      return 2;
    } else if (level <= 8) {
      return 3;
    } else if (level <= 12) {
      return 4;
    } else if (level <= 16) {
      return 5;
    } else {
      return 6;
    }
  }

  int get armorClass =>
      _activeTransformation?.armorClass ??
      (10 + stats.wisdom.modifier + stats.dexterity.modifier);

  int get passivePerception =>
      _activeTransformation?.passivePerception ?? _calculatePassivePerception();

  int _calculatePassivePerception() {
    int score = stats.wisdom.modifier + 10;

    for (var source in [
      modifiers.race,
      modifiers.classModifier,
      modifiers.background,
      modifiers.feat,
      modifiers.condition,
      modifiers.item,
    ]) {
      for (var modifiers in source) {
        if (modifiers.type == ModifierType.proficiency &&
            modifiers.subType == ModifierSubType.perception) {
          score += proficiencyBonus;
        }
      }
    }

    return score;
  }

  int get passiveInvestigation {
    int score = stats.intelligence.modifier + 10;

    for (var source in [
      modifiers.race,
      modifiers.classModifier,
      modifiers.background,
      modifiers.feat,
    ]) {
      for (var modifiers in source) {
        if (modifiers.type == ModifierType.proficiency &&
            modifiers.subType == ModifierSubType.investigation) {
          score += proficiencyBonus;
        }
      }
    }

    return score;
  }

  int get passiveInsight {
    int score = stats.wisdom.modifier + 10;

    for (var source in [
      modifiers.race,
      modifiers.classModifier,
      modifiers.background,
      modifiers.feat,
    ]) {
      for (var modifiers in source) {
        if (modifiers.type == ModifierType.proficiency &&
            modifiers.subType == ModifierSubType.insight) {
          score += proficiencyBonus;
        }
      }
    }

    return score;
  }

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
      currency: Currency.fromJson(json['currencies']),
      creatures: (json['creatures'] as List<dynamic>?)
              ?.map((x) => Creature.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      initiative: null,
      tiebreaker: 0,
    );
  }
}
