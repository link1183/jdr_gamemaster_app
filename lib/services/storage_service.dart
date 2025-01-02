import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StorageService');

class StorageService {
  static const String _charactersFileName = 'characters.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _charactersFile async {
    final path = await _localPath;
    return File('$path/$_charactersFileName');
  }

  Future<List<int>> loadCharacterIds() async {
    try {
      final file = await _charactersFile;

      // If file doesn't exist, create it with default values
      if (!await file.exists()) {
        await _createDefaultCharactersFile();
      }

      final String contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);

      // Convert the dynamic list to List<String>
      return jsonList.map((item) => item as int).toList();
    } catch (e) {
      _logger.severe('Error loading character IDs', e);
      return [];
    }
  }

  Future<void> saveCharacterIds(List<int> characterIds) async {
    try {
      final file = await _charactersFile;
      await file.writeAsString(json.encode(characterIds));
      _logger.info('Character IDs saved successfully');
    } catch (e) {
      _logger.severe('Error saving character IDs', e);
      throw Exception('Failed to save character IDs: $e');
    }
  }

  Future<void> _createDefaultCharactersFile() async {
    final defaultCharacters = [
      133116028, // Selenna
      132627929, // Lorakk
      133113999, // Facilier
      132588957, // Merlin
      138231200, // Hikari
    ];

    await saveCharacterIds(defaultCharacters);
  }
}
