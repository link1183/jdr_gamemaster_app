import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'models/app_state.dart';
import 'screens/character_list/character_list_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('Stack trace:\n${record.stackTrace}');
    }
  });

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        setWindowMinSize(Size(
          800, 700
        ));
      }

      return ChangeNotifierProvider(
        create: (context) {
          final appState = AppState();
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
