class Class {
  final int level;
  final ClassDefinition? definition;
  final ClassDefinition? subClassDefinition;

  Class({
    required this.level,
    required this.definition,
    this.subClassDefinition,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      level: json['level'] as int? ?? 0,
      definition: json['definition'] != null
          ? ClassDefinition.fromJson(json['definition'] as Map<String, dynamic>)
          : null,
      subClassDefinition: json['subclassDefinition'] != null
          ? ClassDefinition.fromJson(
              json['subclassDefinition'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ClassDefinition {
  final String name;

  ClassDefinition({
    required this.name,
  });

  factory ClassDefinition.fromJson(Map<String, dynamic> json) {
    return ClassDefinition(
      name: json['name'] as String? ?? '',
    );
  }
}
