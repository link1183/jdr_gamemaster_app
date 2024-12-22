import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../models/character.dart';
import 'widgets/party_health_stats.dart';
import 'widgets/character_list_item.dart';
import 'widgets/reset_initiatives_button.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    Provider.of<AppState>(context, listen: false).initializeCharacters();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _shouldShowTurnOrder(Character character) {
    return character.initiative != null;
  }

  void _handleResetInitiatives() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.resetInitiative();
    _controllers.forEach((key, controller) {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statut du groupe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text('Actualisation des données...'),
                    ],
                  ),
                  duration: Duration(milliseconds: 1000),
                ),
              );

              await Provider.of<AppState>(context, listen: false)
                  .initializeCharacters();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 16),
                        Text('Données actualisées avec succès'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            tooltip: 'Actualiser les données',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (appState.characterList.isEmpty)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                PartyHealthStats(
                  healthStats: appState.getHealthStats(),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: appState.characterList.length,
                    itemBuilder: (context, index) {
                      final character = appState.characterList[index];
                      return CharacterListItem(
                        character: character,
                        controller: _controllers.putIfAbsent(
                          character.name,
                          () => TextEditingController(
                            text: character.initiative?.toString() ?? '',
                          ),
                        ),
                        onSort: appState.sortByInitiative,
                        index: index,
                        showTurnOrder: _shouldShowTurnOrder(character),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          if (appState.characterList.isNotEmpty)
            ResetInitiativesButton(
              onReset: _handleResetInitiatives,
            ),
        ],
      ),
    );
  }
}
