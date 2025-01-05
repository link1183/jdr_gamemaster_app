import 'package:jdr_gamemaster_app/models/enums.dart';

class InventoryItem {
  final ItemDefinition definition;
  final int quantity;
  final bool isEquipped;

  InventoryItem({
    required this.definition,
    required this.quantity,
    required this.isEquipped,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      definition: ItemDefinition.fromJson(json['definition']),
      quantity: json['quantity'] as int,
      isEquipped: json['equipped'] as bool,
    );
  }
}

class ItemDefinition {
  final String name;
  final String type;
  final String description;
  final List<GrantedModifier> grantedModifiers;
  final List<WeaponBehavior> weaponBehaviors;
  final String filterType;
  final int armorClass;
  final bool isMonkWeapon;
  final int armorTypeId;

  ItemDefinition({
    required this.name,
    required this.type,
    required this.description,
    required this.grantedModifiers,
    required this.filterType,
    required this.armorClass,
    required this.isMonkWeapon,
    required this.weaponBehaviors,
    required this.armorTypeId,
  });

  factory ItemDefinition.fromJson(Map<String, dynamic> json) {
    return ItemDefinition(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String,
      grantedModifiers: (json['grantedModifiers'] as List<dynamic>)
          .map<GrantedModifier>((dynamic x) =>
              GrantedModifier.fromJson(x as Map<String, dynamic>))
          .toList(),
      weaponBehaviors: (json['weaponBehaviors'] as List<dynamic>)
          .map<WeaponBehavior>((dynamic x) => WeaponBehavior.fromJson(x))
          .toList(),
      filterType: json['filterType'] as String? ?? '',
      armorClass: json['armorClass'] as int? ?? 10,
      isMonkWeapon: json['isMonkWeapon'] as bool? ?? false,
      armorTypeId: json['armorTypeId'] as int? ?? 0,
    );
  }
}

class GrantedModifier {
  final int fixedValue;
  final ModifierType type;
  final ModifierSubType subType;
  final Ability stat;

  GrantedModifier(
      {required this.fixedValue,
      required this.type,
      required this.subType,
      required this.stat});

  factory GrantedModifier.fromJson(Map<String, dynamic> json) {
    return GrantedModifier(
      fixedValue: json['fixedValue'] as int? ?? 0,
      type: ModifierTypeExtension.getModifier(json['type']),
      subType: ModifierSubTypeExtension.getModifier(json['subType']),
      stat: AbilityExtension.getStat(json['statId'] as int?),
    );
  }
}

class WeaponBehavior {
  final String type;
  final WeaponDamage damage;
  final String damageType;
  final bool isMonkWeapon;

  WeaponBehavior(
      {required this.type,
      required this.damage,
      required this.damageType,
      required this.isMonkWeapon});

  factory WeaponBehavior.fromJson(Map<String, dynamic> json) {
    return WeaponBehavior(
      type: json['type'] as String,
      damage: WeaponDamage.fromJson(json['damage'] as Map<String, dynamic>),
      damageType: json['damageType'] as String,
      isMonkWeapon: json['isMonkWeapon'] as bool,
    );
  }
}

class WeaponDamage {
  final int diceCount;
  final int diceValue;
  final int diceMultiplier;
  final int fixedValue;

  WeaponDamage(
      {required this.diceCount,
      required this.diceValue,
      required this.diceMultiplier,
      required this.fixedValue});

  factory WeaponDamage.fromJson(Map<String, dynamic> json) {
    return WeaponDamage(
      diceCount: json['diceCount'] as int? ?? 0,
      diceValue: json['diceValue'] as int? ?? 0,
      diceMultiplier: json['diceMultiplier'] as int? ?? 1,
      fixedValue: json['diceValue'] as int? ?? 0,
    );
  }
}
