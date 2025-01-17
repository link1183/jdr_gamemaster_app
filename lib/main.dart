import 'package:flutter/material.dart';
import 'package:jdr_gamemaster_app/services/logging_service.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'models/app_state.dart';
import 'screens/character_list/character_list_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final LoggingService loggingService = LoggingService();
  await loggingService.initialize(
    logLevel: Level.INFO,
  );

  final Logger logger = loggingService.getLogger('Main');
  logger.info('Application started');

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        setWindowMinSize(const Size(1000, 700));
      }

      return ChangeNotifierProvider<AppState>(
        create: (BuildContext context) {
          final AppState appState = AppState();
          appState.loadCharacterIds();
          return appState;
        },
        child: MaterialApp(
          title: 'JDR Gamemaster App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          ),
          home: const CharacterListScreen(),
        ),
      );
    });
  }
}
