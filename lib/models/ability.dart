import 'package:jdr_gamemaster_app/models/enums.dart';
import 'character.dart';
import 'modifier.dart';

class AbilityScore {
  final Ability name;
  final int baseValue;
  final Character? character;

  AbilityScore({
    required this.name,
    required this.baseValue,
    this.character,
  });

  int get value {
    if (character == null) return baseValue;
    return _getScore(character!);
  }

  int get modifier => ((value - 10) / 2).floor();

  int _getScore(Character character) {
    int totalScore = baseValue;
    ModifierSubType subType = _getAbilityScoreSubType(name);
    if (subType == ModifierSubType.notFound) return totalScore;

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

  factory AbilityScore.fromJson(Map<String, dynamic> json,
      {Character? character}) {
    // First handle the statId/name mapping
    Ability name;
    if (json.containsKey('id')) {
      name = switch (json['id'] as int) {
        1 => Ability.strength,
        2 => Ability.dexterity,
        3 => Ability.constitution,
        4 => Ability.intelligence,
        5 => Ability.wisdom,
        6 => Ability.charisma,
        _ => Ability.notFound
      };
    } else {
      name = switch (json['statId'] as int?) {
        1 => Ability.strength,
        2 => Ability.dexterity,
        3 => Ability.constitution,
        4 => Ability.intelligence,
        5 => Ability.wisdom,
        6 => Ability.charisma,
        _ => Ability.notFound
      };
    }

    // Then handle the value
    int value;
    if (json.containsKey('value')) {
      value = json['value'] as int? ?? 10;
    } else if (json.containsKey('statValue')) {
      value = json['statValue'] as int? ?? 10;
    } else {
      value = 10; // default value
    }

    return AbilityScore(
      name: name,
      baseValue: value,
      character: character,
    );
  }
}

class AbilityScores {
  final List<AbilityScore> _scores;
  final Character? _character;

  AbilityScores(List<AbilityScore> scores, [this._character])
      : _scores = scores
            .map((score) => AbilityScore(
                name: score.name,
                baseValue: score.baseValue,
                character: _character))
            .toList();

  AbilityScore getAbilityScore(Ability ability) {
    return _scores.firstWhere(
      (score) => score.name == ability,
      orElse: () =>
          AbilityScore(name: ability, baseValue: 10, character: _character),
    );
  }

  AbilityScore get strength => getAbilityScore(Ability.strength);
  AbilityScore get dexterity => getAbilityScore(Ability.dexterity);
  AbilityScore get constitution => getAbilityScore(Ability.constitution);
  AbilityScore get intelligence => getAbilityScore(Ability.intelligence);
  AbilityScore get wisdom => getAbilityScore(Ability.wisdom);
  AbilityScore get charisma => getAbilityScore(Ability.charisma);
}
