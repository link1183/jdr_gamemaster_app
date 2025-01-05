import 'package:flutter/foundation.dart';
import 'package:jdr_gamemaster_app/models/creature.dart';
import 'package:jdr_gamemaster_app/services/logging_service.dart';
import 'package:jdr_gamemaster_app/services/storage_service.dart';
import '../services/character_service.dart';
import 'character.dart';

class AppState extends ChangeNotifier {
  final _logger = LoggingService().getLogger('AppState');
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

  Future<bool> editCharacter(int oldId, int newId) async {
    try {
      if (!characterIds.contains(oldId)) return false;
      characterIds =
          characterIds.map((id) => oldId == id ? newId : id).toList();
      await _storageService.saveCharacterIds(characterIds);
      return true;
    } catch (e) {
      _logger.severe('Error editing character', e);
      return false;
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
    // Store current transformations before refresh
    Map<int, Creature?> currentTransformations = {};
    for (var character in characterList) {
      if (character.activeTransformation != null) {
        currentTransformations[character.id] = character.activeTransformation;
      }
    }

    // Load new data
    final List<Character> newCharacters = await loadCharacters();

    // Restore transformations
    for (var character in newCharacters) {
      if (currentTransformations.containsKey(character.id)) {
        // Find the matching creature in the new data
        final oldCreatureId = currentTransformations[character.id]?.id;
        if (oldCreatureId != null) {
          final newCreature = character.creatures.firstWhere(
            (c) => c.id == oldCreatureId,
            orElse: () {
              _logger.warning(
                  'Could not find creature $oldCreatureId for character ${character.id}');
              return character.creatures.first;
            },
          );
          if (newCreature.id == oldCreatureId) {
            character.transform(newCreature);
          }
        }
      }
    }

    characterList = newCharacters;
    notifyListeners();
  }

  void notifyCharacterChanged() {
    notifyListeners();
  }

  Future<List<Character>> loadCharacters() async {
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
        _logger.severe('Error processing character $id', e);
      }
    }).toList();

    await Future.wait(futures);

    isLoading = false;
    _logger.info('Finished loading all characters');

    return characterIds
        .where((id) => tempCharacters.containsKey(id))
        .map((id) => tempCharacters[id]!)
        .toList();
  }

  Map<String, dynamic> getHealthStats() {
    if (characterList.isEmpty) {
      return {
        'categories': {
          'healthy': 0,
          'injured': 0,
          'bloodied': 0,
          'critical': 0,
        },
        'percent': 0,
        'transformedCount': 0
      };
    }

    double sum = 0;
    double baseSum = 0;
    int transformedCount = 0;
    Map<String, int> categories = {
      'healthy': 0,
      'injured': 0,
      'bloodied': 0,
      'critical': 0,
    };

    for (Character character in characterList) {
      if (character.activeTransformation != null) {
        transformedCount++;
      }

      // Use transformed stats if available
      final health = character.activeTransformation?.currentHealth ??
          character.currentHealth;
      final maxHealth = character.activeTransformation?.averageHitPoints ??
          character.maxHealth;
      final healthPercent = (health / maxHealth) * 100;

      if (healthPercent > 75) {
        categories['healthy'] = categories['healthy']! + 1;
      } else if (healthPercent > 50) {
        categories['injured'] = categories['injured']! + 1;
      } else if (healthPercent > 25) {
        categories['bloodied'] = categories['bloodied']! + 1;
      } else {
        categories['critical'] = categories['critical']! + 1;
      }

      sum += health;
      baseSum += maxHealth;
    }

    return {
      'categories': categories,
      'percent': ((sum / baseSum) * 100).round(),
      'transformedCount': transformedCount,
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
