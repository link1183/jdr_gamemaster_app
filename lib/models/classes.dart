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
      subClassDefinition: json['subClassDefinition'] != null
          ? ClassDefinition.fromJson(
              json['subClassDefinition'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ClassDefinition {
  final String name;
  final String description;

  ClassDefinition({required this.name, required this.description});

  factory ClassDefinition.fromJson(Map<String, dynamic> json) {
    return ClassDefinition(
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '');
  }
}
