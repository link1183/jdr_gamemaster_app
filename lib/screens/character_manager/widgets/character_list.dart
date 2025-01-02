import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_state.dart';
import 'character_item.dart';

class CharacterList extends StatelessWidget {
  const CharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return ListView.builder(
          itemCount: appState.characterIds.length,
          itemBuilder: (context, index) {
            final id = appState.characterIds[index];
            final character =
                appState.characterList.where((c) => c.id == id).firstOrNull;
            final name = character?.name ?? 'Chargement...';

            return CharacterItem(
              index: index,
              id: id,
              name: name,
            );
          },
        );
      },
    );
  }
}
