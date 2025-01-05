import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toastification/toastification.dart';
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

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (localContext) => AlertDialog(
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
      if (!context.mounted) return;
      final success = await appState.removeCharacter(id, context);
      if (success && context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          title: const Text("Succès"),
          description: const Text("Personnage supprimé avec succès."),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 4),
          boxShadow: highModeShadow,
          showProgressBar: false,
          closeOnClick: true,
          applyBlurEffect: true,
        );
      }
    }
  }

  Future<void> _openLink(BuildContext context) async {
    final Uri url = Uri.parse('https://www.dndbeyond.com/characters/$id');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch URL';
      }
    } catch (e) {
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: const Text("Erreur"),
          description: Text("Erreur en ouvrant le lien : $e"),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 4),
          boxShadow: highModeShadow,
          showProgressBar: false,
          closeOnClick: true,
          applyBlurEffect: true,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded),
            onPressed: () => _openLink(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeSelected(context),
          ),
        ],
      ),
    );
  }
}
