import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../models/character.dart';
import 'widgets/party_health_stats.dart';
import 'widgets/character_list_item.dart';
import 'widgets/reset_initiatives_button.dart';
import '../character_manager/character_manager_screen.dart';

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

  Future<void> _refreshCharacterList() async {
    if (!context.mounted) return;
    await Provider.of<AppState>(context, listen: false).initializeCharacters();
  }

  Future<void> _handleRefresh() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!context.mounted) return;

    messenger.showSnackBar(
      const SnackBar(
          content: Text('Actualisation des données...'),
          duration: Duration(milliseconds: 1000)),
    );

    await _refreshCharacterList();

    if (!context.mounted) return;
    messenger.showSnackBar(
      const SnackBar(
          content: Text('Données actualisées avec succès'),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statut du groupe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CharacterManagerScreen(),
                ),
              ).then((_) => _refreshCharacterList());
            },
            tooltip: 'Gérer les personnages',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleRefresh,
            tooltip: 'Actualiser les données',
          ),
        ],
      ),

      // Body
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

                      bool hasSameInitiativeAbove = false;
                      if (index > 0 && character.initiative != null) {
                        hasSameInitiativeAbove =
                            appState.characterList[index - 1].initiative ==
                                character.initiative;
                      }

                      bool hasSameInitiativeBelow = false;
                      if (index < appState.characterList.length - 1 &&
                          character.initiative != null) {
                        hasSameInitiativeBelow =
                            appState.characterList[index + 1].initiative ==
                                character.initiative;
                      }

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
                        onMoveUp: hasSameInitiativeAbove
                            ? () => appState.moveCharacterUp(character)
                            : null,
                        onMoveDown: hasSameInitiativeBelow
                            ? () => appState.moveCharacterDown(character)
                            : null,
                        hasSameInitiativeAbove: hasSameInitiativeAbove,
                        hasSameInitiativeBelow: hasSameInitiativeBelow,
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
