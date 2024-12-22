enum Ability {
  strength,
  dexterity,
  constitution,
  intelligence,
  wisdom,
  charisma,
  notFound
}

extension AbilityExtension on Ability {
  static Ability getStat(int? stat) {
    return switch (stat) {
      1 => Ability.strength,
      2 => Ability.dexterity,
      3 => Ability.constitution,
      4 => Ability.intelligence,
      5 => Ability.wisdom,
      6 => Ability.charisma,
      _ => Ability.notFound,
    };
  }
}

enum ModifierType {
  // Core modifier types
  bonus, // Numerical bonuses
  proficiency, // Skill and equipment proficiencies
  advantage, // Advantage on checks/saves
  resistance, // Damage resistances
  damage, // Damage modifications
  weaponMastery, // Weapon mastery abilities
  setBase, // Base value settings
  monkWeapon, // Monk weapon designations

  // Character attributes
  sense, // Sensory abilities
  size, // Size category
  language, // Known languages
  expertise, // Expertise in skills

  // Miscellaneous
  set, // Setting specific values
  notFound // Default/error case
}

extension ModifierTypeExtension on ModifierType {
  static ModifierType getModifier(String? type) {
    return switch (type) {
      'bonus' => ModifierType.bonus,
      'proficiency' => ModifierType.proficiency,
      'advantage' => ModifierType.advantage,
      'resistance' => ModifierType.resistance,
      'damage' => ModifierType.damage,
      'weapon-mastery' => ModifierType.weaponMastery,
      'set-base' => ModifierType.setBase,
      'monk-weapon' => ModifierType.monkWeapon,
      'sense' => ModifierType.sense,
      'size' => ModifierType.size,
      'language' => ModifierType.language,
      'expertise' => ModifierType.expertise,
      'set' => ModifierType.set,
      _ => ModifierType.notFound,
    };
  }
}

enum ModifierSubType {
  // Combat & Defense
  armorClass,
  unarmoredArmorClass,
  savingThrows,
  strengthSavingThrows,
  dexteritySavingThrows,
  constitutionSavingThrows,
  intelligenceSavingThrows,
  wisdomSavingThrows,
  charismaSavingThrows,

  // Armor & Weapons
  lightArmor,
  mediumArmor,
  heavyArmor,
  shields,
  simpleWeapons,
  martialWeapons,
  crossbowHand,
  scimitar,
  shortsword,

  // Movement & Actions
  unarmoredMovement,
  extraAttacks,
  hitPoints,

  // Combat Abilities
  strengthAttacks,
  unarmedAttacks,

  // Ability Scores
  strengthScore,
  dexterityScore,
  constitutionScore,
  intelligenceScore,
  wisdomScore,
  charismaScore,
  chooseAnAbilityScore,

  // Skills
  acrobatics,
  athletics,
  history,
  arcana,
  insight,
  investigation,
  medicine,
  perception,
  stealth,
  survival,
  sleightOfHand,
  deception,
  nature,
  intimidation,
  persuasion,

  // Tools & Equipment
  alchemistsSupplies,
  herbalismKit,
  calligraphersSupplies,
  poisonersKit,
  thievesTools,
  dragonchessSet,
  flute,

  // Magic & Spells
  magic,
  spellAttacks,
  druidCantripDamage,
  self,

  // Movement & Senses
  darkvision,
  innateSpeedFlying,
  speed,
  initiative,

  // Languages
  common,
  elvish,
  commonSignLanguage,
  orc,
  infernal,
  goblin,
  draconic,
  druidic,
  dwarvish,
  abyssal,
  undercommon,
  deepSpeech,

  // Damage & Resistance
  force,
  fire,
  acid,
  necrotic,

  // Special Features & Choices
  medium,
  subclass,
  chooseABloodHunterSkill,
  chooseABarbarianSkill,
  chooseAFighterSkillProficiency,
  notFound
}

extension ModifierSubTypeExtension on ModifierSubType {
  static ModifierSubType getModifier(String? type) {
    return switch (type) {
      // Combat & Defense
      'armor-class' => ModifierSubType.armorClass,
      'unarmored-armor-class' => ModifierSubType.unarmoredArmorClass,
      'saving-throws' => ModifierSubType.savingThrows,
      'strength-saving-throws' => ModifierSubType.strengthSavingThrows,
      'dexterity-saving-throws' => ModifierSubType.dexteritySavingThrows,
      'constitution-saving-throws' => ModifierSubType.constitutionSavingThrows,
      'intelligence-saving-throws' => ModifierSubType.intelligenceSavingThrows,
      'wisdom-saving-throws' => ModifierSubType.wisdomSavingThrows,
      'charisma-saving-throws' => ModifierSubType.charismaSavingThrows,
      'hit-points' => ModifierSubType.hitPoints,

      // Armor & Weapons
      'light-armor' => ModifierSubType.lightArmor,
      'medium-armor' => ModifierSubType.mediumArmor,
      'heavy-armor' => ModifierSubType.heavyArmor,
      'shields' => ModifierSubType.shields,
      'simple-weapons' => ModifierSubType.simpleWeapons,
      'martial-weapons' => ModifierSubType.martialWeapons,
      'crossbow-hand' => ModifierSubType.crossbowHand,
      'scimitar' => ModifierSubType.scimitar,
      'shortsword' => ModifierSubType.shortsword,

      // Movement & Actions
      'unarmored-movement' => ModifierSubType.unarmoredMovement,
      'extra-attacks' => ModifierSubType.extraAttacks,

      // Combat Abilities
      'unarmed-attacks' => ModifierSubType.unarmedAttacks,

      // Ability Scores
      'strength-score' => ModifierSubType.strengthScore,
      'dexterity-score' => ModifierSubType.dexterityScore,
      'constitution-score' => ModifierSubType.constitutionScore,
      'intelligence-score' => ModifierSubType.intelligenceScore,
      'wisdom-score' => ModifierSubType.wisdomScore,
      'charisma-score' => ModifierSubType.charismaScore,

      // Skills
      'acrobatics' => ModifierSubType.acrobatics,
      'athletics' => ModifierSubType.athletics,
      'history' => ModifierSubType.history,
      'arcana' => ModifierSubType.arcana,
      'insight' => ModifierSubType.insight,
      'medicine' => ModifierSubType.medicine,
      'perception' => ModifierSubType.perception,
      'stealth' => ModifierSubType.stealth,
      'survival' => ModifierSubType.survival,
      'sleight-of-hand' => ModifierSubType.sleightOfHand,

      // Tools
      'herbalism-kit' => ModifierSubType.herbalismKit,
      'flute' => ModifierSubType.flute,

      // Languages
      'common' => ModifierSubType.common,
      'elvish' => ModifierSubType.elvish,
      'infernal' => ModifierSubType.infernal,
      'dwarvish' => ModifierSubType.dwarvish,

      // Features
      'subclass' => ModifierSubType.subclass,
      _ => ModifierSubType.notFound,
    };
  }
}
