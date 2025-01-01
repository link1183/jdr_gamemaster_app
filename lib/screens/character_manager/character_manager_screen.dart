import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class CharacterManagerScreen extends StatefulWidget {
  const CharacterManagerScreen({super.key});

  @override
  State<CharacterManagerScreen> createState() => _CharacterManagerScreenState();
}

class _CharacterManagerScreenState extends State<CharacterManagerScreen> {
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _processBatchIds() async {
    setState(() => _isLoading = true);

    try {
      final ids = _textController.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .map((s) => int.parse(s))
          .toList();

      final results = <int, bool>{};
      for (final id in ids) {
        results[id] = await Provider.of<AppState>(context, listen: false)
            .addCharacter(id);
      }

      if (mounted) {
        final successful = results.values.where((v) => v).length;
        final failed = results.values.where((v) => !v).length;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$successful ajoutés, $failed échecs'),
            backgroundColor: failed == 0 ? Colors.green : Colors.orange,
          ),
        );
        _textController.clear();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removeSelected(List<int> ids) async {
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);

      try {
        int successful = 0;
        for (final id in ids) {
          if (await Provider.of<AppState>(context, listen: false)
              .removeCharacter(id)) {
            successful++;
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$successful personnages supprimés'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des personnages'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'IDs des personnages',
                        hintText: 'Un ID par ligne',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _processBatchIds,
                      child: const Text('Ajouter les personnages'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<AppState>(
                  builder: (context, appState, child) {
                    return ListView.builder(
                      itemCount: appState.characterIds.length,
                      itemBuilder: (context, index) {
                        final id = appState.characterIds[index];
                        final character = appState.characterList
                            .where((c) => c.id == id)
                            .firstOrNull;
                        final name = character?.name ?? 'Chargement...';

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(name),
                          subtitle: Text(id.toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed:
                                _isLoading ? null : () => _removeSelected([id]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
