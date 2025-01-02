import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_state.dart';
import 'character_id_actions.dart';

class CharacterItem extends StatelessWidget {
  final int index;
  final int id;
  final String name;

  const CharacterItem({
    required this.index,
    required this.id,
    required this.name,
    super.key,
  });

  Future<void> _removeSelected(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content:
            const Text('Êtes-vous sûr de vouloir supprimer ce personnage ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await appState.removeCharacter(id);
      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Personnage supprimé'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text(name),
      subtitle: Row(
        children: [
          Text(id.toString()),
          CharacterIdActions(id: id),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeSelected(context),
      ),
    );
  }
}
