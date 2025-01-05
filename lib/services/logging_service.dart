import 'dart:io';
import 'package:jdr_gamemaster_app/services/shared_variables.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart' as path;

class LoggingService {
  static const String _logFileName = 'app.log';
  final String _appFolderName = SharedVariables().appFolderName;
  static final LoggingService _instance = LoggingService._internal();

  final Lock _lock = Lock();

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
      final Directory directory =
          Directory(path.join(appDataPath, _appFolderName));
      await directory.create(recursive: true);
      return directory.path;
    } else if (Platform.isLinux) {
      final String homeDir = Platform.environment['HOME'] ?? '';
      if (homeDir.isEmpty) {
        throw Exception('Could not find HOME directory');
      }
      final Directory directory =
          Directory(path.join(homeDir, '.local', 'share', _appFolderName));
      await directory.create(recursive: true);
      return directory.path;
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      final Directory appDirectory =
          Directory(path.join(directory.path, _appFolderName));
      await appDirectory.create(recursive: true);
      return appDirectory.path;
    }
  }

  Future<File> _getLogFile() async {
    final String path = await _localPath;
    return File('$path/$_logFileName');
  }

  Future<void> initialize({Level logLevel = Level.ALL}) async {
    final File logFile = await _getLogFile();

    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
    }

    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((LogRecord record) async {
      await _lock.synchronized(() async {
        final String logMessage =
            '${record.time}: ${record.level.name}: ${record.loggerName}: ${record.message}${record.error != null ? '\nError: ${record.error}' : ''}${record.stackTrace != null ? '\nStack Trace: ${record.stackTrace}' : ''}\n';

        await logFile.writeAsString(logMessage, mode: FileMode.append);
      });
    });
  }

  Logger getLogger(String name) {
    return Logger(name);
  }
}
