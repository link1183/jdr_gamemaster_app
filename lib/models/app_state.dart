import 'dart:math';
import 'package:flutter/foundation.dart';
import '../services/character_service.dart';
import 'character.dart';
import 'package:logging/logging.dart';

final _logger = Logger('AppState');

class AppState extends ChangeNotifier {
  Map<String, int> characterIds = {
    '133116028': 16, // Selenna
    '132627929': 21, // Lorakk
    '133113999': 21, // Facilier
    '132588957': 18, // Merlin
    '138231200': 15 // Hikari
  };
  List<Character> characterList = [];

  Future<void> initializeCharacters() async {
    Map<String, Character> tempCharacters = {};
    List<Future<void>> futures = characterIds.entries.map((character) async {
      try {
        Map<String, dynamic> characterJson =
            await CharacterService.fetchCharacterData(character.key);
        Character c = Character.fromJson(characterJson);
        tempCharacters[character.key] = c;
        _logger.info('Successfully loaded character ${character.key}');
      } catch (e) {
        _logger.severe('Error processing character ${character.key}: $e', e,
            StackTrace.current);
      }
    }).toList();
    await Future.wait(futures);

    characterList = characterIds.keys
        .where((key) => tempCharacters.containsKey(key))
        .map((key) => tempCharacters[key]!)
        .toList();

    _logger.info('Finished loading all characters');
    notifyListeners();
  }

  Map<String, int> getHealthStats() {
    if (characterList.isEmpty) return {'avg': 0, 'variance': 0, 'percent': 0};

    double sum = 0;
    double baseSum = 0;
    List<int> healthValues = [];

    for (Character character in characterList) {
      int health = character.currentHealth;
      sum += health;
      baseSum += character.maxHealth;
      healthValues.add(health);
    }

    double mean = sum / characterList.length;
    double variance = 0;

    for (int health in healthValues) {
      variance += (health - mean) * (health - mean);
    }
    variance = (variance / characterList.length).round().toDouble();
    double standardDeviation = sqrt(variance);

    return {
      'avg': mean.round(),
      'variance': standardDeviation.round(),
      'percent': ((sum / baseSum) * 100).round()
    };
  }

  void sortByInitiative() {
    characterList.sort((a, b) {
      if (a.initiative == null && b.initiative == null) return 0;
      if (a.initiative == null) return 1;
      if (b.initiative == null) return -1;
      return b.initiative!.compareTo(a.initiative!);
    });
    notifyListeners();
  }

  void resetInitiative() {
    for (var character in characterList) {
      character.initiative = null;
    }
    notifyListeners();
  }
}
