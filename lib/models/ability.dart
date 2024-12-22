import 'package:jdr_gamemaster_app/models/enums.dart';
import 'character.dart';
import 'modifier.dart';

class AbilityScore {
  final Ability name;
  final int value;

  AbilityScore({
    required this.name,
    required this.value,
  });

  int _getScore(Character character) {
    int totalScore = value;

    // Get the corresponding ModifierSubType for this ability
    ModifierSubType subType = _getAbilityScoreSubType(name);
    if (subType == ModifierSubType.notFound) return totalScore;

    // Process all modifier sources
    for (var source in [
      character.modifiers.race,
      character.modifiers.classModifier,
      character.modifiers.background,
      character.modifiers.feat
    ]) {
      for (var modifier in source) {
        if (_isRelevantModifier(modifier, subType)) {
          totalScore += modifier.fixedValue;
        }
      }
    }

    return totalScore;
  }

  bool _isRelevantModifier(ClassModifier modifier, ModifierSubType subType) {
    return modifier.type == ModifierType.bonus && modifier.subType == subType;
  }

  ModifierSubType _getAbilityScoreSubType(Ability ability) {
    return switch (ability) {
      Ability.strength => ModifierSubType.strengthScore,
      Ability.dexterity => ModifierSubType.dexterityScore,
      Ability.constitution => ModifierSubType.constitutionScore,
      Ability.intelligence => ModifierSubType.intelligenceScore,
      Ability.wisdom => ModifierSubType.wisdomScore,
      Ability.charisma => ModifierSubType.charismaScore,
      _ => ModifierSubType.notFound,
    };
  }

  factory AbilityScore.fromJson(Map<String, dynamic> json) {
    Ability name = switch (json['id'] as int) {
      1 => Ability.strength,
      2 => Ability.dexterity,
      3 => Ability.constitution,
      4 => Ability.intelligence,
      5 => Ability.wisdom,
      6 => Ability.charisma,
      _ => Ability.notFound
    };

    return AbilityScore(
      name: name,
      value: (json['value'] as int?) ?? 10,
    );
  }
}

class AbilityScores {
  final List<AbilityScore> _scores;
  final Character _character;

  AbilityScores(this._scores, this._character);

  AbilityScore getAbilityScore(Ability ability) {
    return _scores.firstWhere(
      (score) => score.name == ability,
      orElse: () => AbilityScore(name: ability, value: 10),
    );
  }

  int getModifier(int value) {
    return ((value - 10) / 2).floor();
  }

  int get strength => getAbilityScore(Ability.strength)._getScore(_character);
  int get dexterity => getAbilityScore(Ability.dexterity)._getScore(_character);
  int get constitution =>
      getAbilityScore(Ability.constitution)._getScore(_character);
  int get intelligence =>
      getAbilityScore(Ability.intelligence)._getScore(_character);
  int get wisdom => getAbilityScore(Ability.wisdom)._getScore(_character);
  int get charisma => getAbilityScore(Ability.charisma)._getScore(_character);
}
