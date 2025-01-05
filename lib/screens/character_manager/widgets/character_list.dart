import 'package:flutter/material.dart';
import 'package:jdr_gamemaster_app/models/character.dart';
import 'package:provider/provider.dart';
import '../../../models/app_state.dart';
import 'character_item.dart';

class CharacterList extends StatelessWidget {
  const CharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        return ListView.builder(
          itemCount: appState.characterIds.length,
          itemBuilder: (BuildContext context, int index) {
            final int id = appState.characterIds[index];
            final Character? character = appState.characterList
                .where((Character c) => c.id == id)
                .firstOrNull;
            final String name = character?.name ?? 'Chargement...';

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
