import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:jdr_gamemaster_app/services/storage_service.dart';
import '../services/character_service.dart';
import 'character.dart';
import 'package:logging/logging.dart';

final _logger = Logger('AppState');

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<int> characterIds = [];
  List<Character> characterList = [];
  bool isLoading = false;

  Future<void> loadCharacterIds() async {
    try {
      characterIds = await _storageService.loadCharacterIds();
      notifyListeners();
    } catch (e) {
      _logger.severe('Error loading character IDs', e);
    }
  }

  Future<bool> addCharacter(int id) async {
    try {
      // Check if the ID is valid (try to fetch the character)
      await CharacterService.fetchCharacterData(id);

      // If the fetch was successful and the ID isn't already in the list
      if (!characterIds.contains(id)) {
        characterIds.add(id);
        await _storageService.saveCharacterIds(characterIds);
        await initializeCharacters(); // Refresh the full list
        return true;
      }
      return false; // ID already exists
    } catch (e) {
      _logger.severe('Error adding character', e);
      return false; // Invalid ID or network error
    }
  }

  Future<bool> removeCharacter(int id) async {
    try {
      if (characterIds.contains(id)) {
        characterIds.remove(id);
        await _storageService.saveCharacterIds(characterIds);
        characterList.removeWhere((character) => character.id == id);
        notifyListeners();
        return true;
      }
      return false; // ID not found
    } catch (e) {
      _logger.severe('Error removing character', e);
      return false;
    }
  }

  Future<void> initializeCharacters() async {
    if (characterIds.isEmpty) {
      await loadCharacterIds();
    }

    isLoading = true;
    notifyListeners();

    Map<int, Character> tempCharacters = {};
    List<Future<void>> futures = characterIds.map((id) async {
      try {
        Map<String, dynamic> characterJson =
            await CharacterService.fetchCharacterData(id);
        Character c = Character.fromJson(characterJson);
        tempCharacters[id] = c;
        _logger.info('Successfully loaded character $id');
      } catch (e) {
        _logger.severe(
            'Error processing character $id: $e', e, StackTrace.current);
      }
    }).toList();

    await Future.wait(futures);

    characterList = characterIds
        .where((id) => tempCharacters.containsKey(id))
        .map((id) => tempCharacters[id]!)
        .toList();

    isLoading = false;
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

      if (a.initiative != b.initiative) {
        return b.initiative!.compareTo(a.initiative!);
      }

      return b.tiebreaker.compareTo(a.tiebreaker);
    });
    notifyListeners();
  }

  void resetInitiative() {
    for (var character in characterList) {
      character.initiative = null;
    }
    notifyListeners();
  }

  void moveCharacterUp(Character character) {
    final index = characterList.indexOf(character);
    if (index <= 0) return;

    final previousCharacter = characterList[index - 1];
    if (previousCharacter.initiative != character.initiative) return;

    final temp = character.tiebreaker;
    character.tiebreaker = previousCharacter.tiebreaker + 1;
    previousCharacter.tiebreaker = temp;

    sortByInitiative();
  }

  void moveCharacterDown(Character character) {
    final index = characterList.indexOf(character);
    if (index >= characterList.length - 1) return;

    final previousCharacter = characterList[index + 1];
    if (previousCharacter.initiative != character.initiative) return;

    final temp = character.tiebreaker;
    character.tiebreaker = previousCharacter.tiebreaker - 1;
    previousCharacter.tiebreaker = temp;

    sortByInitiative();
  }
}
