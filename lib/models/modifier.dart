import 'package:jdr_gamemaster_app/models/enums.dart';

class Modifier {
  final List<ClassModifier> race;
  final List<ClassModifier> classModifier;
  final List<ClassModifier> background;
  final List<ClassModifier> item;
  final List<ClassModifier> feat;
  final List<ClassModifier> condition;

  Modifier(
      {required this.race,
      required this.classModifier,
      required this.background,
      required this.item,
      required this.feat,
      required this.condition});

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      race: (json['race'] as List<dynamic>)
          .map((x) => ClassModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
      classModifier: (json['class'] as List<dynamic>)
          .map((x) => ClassModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
      background: (json['background'] as List<dynamic>)
          .map((x) => ClassModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
      item: (json['item'] as List<dynamic>)
          .map((x) => ClassModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
      feat: (json['feat'] as List<dynamic>)
          .map((x) => ClassModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
      condition: (json['condition'] as List<dynamic>)
          .map((x) => ClassModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ClassModifier {
  final int fixedValue;
  final ModifierType type;
  final ModifierSubType subType;
  final Ability stat;

  ClassModifier(
      {required this.fixedValue,
      required this.type,
      required this.subType,
      required this.stat});

  factory ClassModifier.fromJson(Map<String, dynamic> json) {
    return ClassModifier(
        fixedValue: json['value'] ?? json['fixedValue'] ?? 0,
        type: ModifierTypeExtension.getModifier(json['type'] as String?),
        subType:
            ModifierSubTypeExtension.getModifier(json['subType'] as String?),
        stat: AbilityExtension.getStat(json['stadId'] as int?));
  }
}
