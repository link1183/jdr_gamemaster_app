import 'dart:io';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart' as path;

class LoggingService {
  static const String _logFileName = 'app.log';
  static const String _appFolderName = 'JDR Gamemaster App';
  static final LoggingService _instance = LoggingService._internal();

  final _lock = Lock();

  factory LoggingService() {
    return _instance;
  }

  LoggingService._internal();

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

  Future<File> _getLogFile() async {
    final path = await _localPath;
    return File('$path/$_logFileName');
  }

  Future<void> initialize({Level logLevel = Level.ALL}) async {
    final logFile = await _getLogFile();

    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
    }

    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((record) async {
      await _lock.synchronized(() async {
        final logMessage =
            '${record.time}: ${record.level.name}: ${record.loggerName}: ${record.message}${record.error != null ? '\nError: ${record.error}' : ''}${record.stackTrace != null ? '\nStack Trace: ${record.stackTrace}' : ''}\n';

        await logFile.writeAsString(logMessage, mode: FileMode.append);
      });
    });
  }

  Logger getLogger(String name) {
    return Logger(name);
  }
}
