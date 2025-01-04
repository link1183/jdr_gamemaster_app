import 'package:jdr_gamemaster_app/models/classes.dart';
import 'package:jdr_gamemaster_app/models/currency.dart';
import 'package:jdr_gamemaster_app/models/enums.dart';
import 'package:jdr_gamemaster_app/models/inventory.dart';
import 'package:jdr_gamemaster_app/models/modifier.dart';
import 'package:jdr_gamemaster_app/models/ability.dart';

typedef JsonObject = Map<String, dynamic>;

class Character {
  int id;
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
  final Currency currency;
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
    required this.currency,
    this.initiative,
    this.tiebreaker = 0,
  }) : _stats = stats {
    this.stats = AbilityScores(_stats, this);
  }

  int get maxHealth => baseHitPoints + stats.constitution.modifier * level;

  int get currentHealth => maxHealth + temporaryHitPoints - removedHitPoints;

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

  int get armorClass {
    int wisMod = stats.wisdom.modifier;
    int dexMod = stats.dexterity.modifier;

    return 10 + wisMod + dexMod;
  }

  int get passivePerception {
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
      initiative: null,
      tiebreaker: 0,
    );
  }
}
