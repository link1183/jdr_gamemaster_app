import 'dart:convert';
import 'dart:io';
import 'package:jdr_gamemaster_app/services/logging_service.dart';
import 'package:jdr_gamemaster_app/services/shared_variables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final Logger _logger;
  StorageService() : _logger = LoggingService().getLogger('StorageService');

  static const String _charactersFileName = 'characters.json';
  final String _appFolderName = SharedVariables().appFolderName;

  Future<String> get _localPath async {
    if (Platform.isWindows) {
      final String appDataPath = Platform.environment['APPDATA'] ?? '';
      if (appDataPath.isEmpty) {
        throw Exception('Could not find APPDATA directory');
      }
      final directory = Directory(path.join(appDataPath, _appFolderName));
      await directory.create(recursive: true);
      return directory.path;
    } else if (Platform.isLinux) {
      final String homeDir = Platform.environment['HOME'] ?? '';
      if (homeDir.isEmpty) {
        throw Exception('Could not find HOME directory');
      }
      final directory =
          Directory(path.join(homeDir, '.local', 'share', _appFolderName));
      await directory.create(recursive: true);
      return directory.path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final appDirectory = Directory(path.join(directory.path, _appFolderName));
      await appDirectory.create(recursive: true);
      return appDirectory.path;
    }
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
      139153342, // Salazar
    ];

    await saveCharacterIds(defaultCharacters);
  }
}
