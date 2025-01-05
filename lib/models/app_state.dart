import 'package:flutter/widgets.dart';
import 'package:jdr_gamemaster_app/models/creature.dart';
import 'package:jdr_gamemaster_app/services/logging_service.dart';
import 'package:jdr_gamemaster_app/services/storage_service.dart';
import 'package:logging/logging.dart';
import 'package:toastification/toastification.dart';
import '../services/character_service.dart';
import 'character.dart';

class AppState extends ChangeNotifier {
  final Logger _logger = LoggingService().getLogger('AppState');
  final StorageService _storageService = StorageService();
  List<int> characterIds = <int>[];
  List<Character> characterList = <Character>[];
  bool isLoading = false;

  void showToast(
      {required BuildContext context,
      required String message,
      ToastificationType type = ToastificationType.error}) {
    toastification.show(
        context: context,
        type: type,
        style: ToastificationStyle.minimal,
        title: Text(message),
        autoCloseDuration: const Duration(seconds: 5));
  }

  Future<void> loadCharacterIds() async {
    try {
      characterIds = await _storageService.loadCharacterIds();
      notifyListeners();
    } catch (e) {
      _logger.severe('Error loading character IDs', e);
    }
  }

  Future<bool> addCharacter(int id, BuildContext context) async {
    try {
      await CharacterService.fetchCharacterData(id);

      if (!characterIds.contains(id)) {
        characterIds.add(id);
        await _storageService.saveCharacterIds(characterIds);
        await initializeCharacters();
        return true;
      }
      return false;
    } catch (e) {
      _logger.severe('Error adding character', e);
      if (!context.mounted) return false;
      showToast(
          context: context,
          message:
              'Failed to add character. Please check the ID and network connection.');
      return false;
    }
  }

  Future<bool> editCharacter(int oldId, int newId) async {
    try {
      if (!characterIds.contains(oldId)) return false;
      characterIds =
          characterIds.map<int>((int id) => oldId == id ? newId : id).toList();
      await _storageService.saveCharacterIds(characterIds);
      return true;
    } catch (e) {
      _logger.severe('Error editing character', e);
      return false;
    }
  }

  Future<bool> removeCharacter(int id, BuildContext? context) async {
    try {
      if (characterIds.contains(id)) {
        characterIds.remove(id);
        await _storageService.saveCharacterIds(characterIds);
        characterList.removeWhere((Character character) => character.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _logger.severe('Error removing character', e);
      if (context != null) {
        showToast(
          context: context,
          message: 'Failed to remove character. Please try again.',
        );
      }
      return false;
    }
  }

  Future<void> initializeCharacters() async {
    Map<int, Creature?> currentTransformations = <int, Creature?>{};
    for (Character character in characterList) {
      if (character.activeTransformation != null) {
        currentTransformations[character.id] = character.activeTransformation;
      }
    }

    final List<Character> newCharacters = await loadCharacters();

    for (Character character in newCharacters) {
      if (currentTransformations.containsKey(character.id)) {
        final int? oldCreatureId = currentTransformations[character.id]?.id;
        if (oldCreatureId != null) {
          final Creature newCreature = character.creatures.firstWhere(
            (Creature c) => c.id == oldCreatureId,
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

  Future<List<Character>> loadCharacters({BuildContext? context}) async {
    if (characterIds.isEmpty) {
      await loadCharacterIds();
    }

    isLoading = true;
    notifyListeners();

    Map<int, Character> tempCharacters = <int, Character>{};
    List<int> failedCharacterIds = <int>[];

    List<Future<void>> futures = characterIds.map<Future<Null>>((id) async {
      try {
        Map<String, dynamic> characterJson =
            await CharacterService.fetchCharacterData(id);
        Character c = Character.fromJson(characterJson);
        tempCharacters[id] = c;
        _logger.info('Successfully loaded character $id');
      } catch (e) {
        _logger.severe('Error processing character $id', e);
        failedCharacterIds.add(id);
      }
    }).toList();

    await Future.wait<void>(futures);

    isLoading = false;
    _logger.info('Finished loading all characters');

    if (failedCharacterIds.isNotEmpty && context != null) {
      if (context.mounted) {
        showToast(
          context: context,
          message: 'Failed to load ${failedCharacterIds.length} character(s). '
              'Check your network connection.',
        );
      }
    }

    return characterIds
        .where((int id) => tempCharacters.containsKey(id))
        .map<Character>((int id) => tempCharacters[id]!)
        .toList();
  }

  Map<String, dynamic> getHealthStats() {
    if (characterList.isEmpty) {
      return <String, dynamic>{
        'categories': <String, int>{
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
    Map<String, int> categories = <String, int>{
      'healthy': 0,
      'injured': 0,
      'bloodied': 0,
      'critical': 0,
    };

    for (Character character in characterList) {
      if (character.activeTransformation != null) {
        transformedCount++;
      }

      final int health = character.activeTransformation?.currentHealth ??
          character.currentHealth;
      final int maxHealth = character.activeTransformation?.averageHitPoints ??
          character.maxHealth;
      final double healthPercent = (health / maxHealth) * 100;

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

    return <String, dynamic>{
      'categories': categories,
      'percent': ((sum / baseSum) * 100).round(),
      'transformedCount': transformedCount,
    };
  }

  void sortByInitiative() {
    characterList.sort((Character a, Character b) {
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
    for (Character character in characterList) {
      character.initiative = null;
    }
    notifyListeners();
  }

  void moveCharacterUp(Character character) {
    final int index = characterList.indexOf(character);
    if (index <= 0) return;

    final Character previousCharacter = characterList[index - 1];
    if (previousCharacter.initiative != character.initiative) return;

    final int temp = character.tiebreaker;
    character.tiebreaker = previousCharacter.tiebreaker + 1;
    previousCharacter.tiebreaker = temp;

    sortByInitiative();
  }

  void moveCharacterDown(Character character) {
    final int index = characterList.indexOf(character);
    if (index >= characterList.length - 1) return;

    final Character previousCharacter = characterList[index + 1];
    if (previousCharacter.initiative != character.initiative) return;

    final int temp = character.tiebreaker;
    character.tiebreaker = previousCharacter.tiebreaker - 1;
    previousCharacter.tiebreaker = temp;

    sortByInitiative();
  }
}
