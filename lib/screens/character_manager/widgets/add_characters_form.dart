import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_state.dart';

class AddCharactersForm extends StatefulWidget {
  const AddCharactersForm({super.key});

  @override
  State<AddCharactersForm> createState() => _AddCharactersFormState();
}

class _AddCharactersFormState extends State<AddCharactersForm> {
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
      final inputLines = _textController.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty);

      final ids = inputLines.map((line) {
        if (line.startsWith('https://www.dndbeyond.com/characters/')) {
          // Extract ID from URL
          final uri = Uri.parse(line);
          final pathSegments = uri.pathSegments;
          if (pathSegments.length >= 2 && pathSegments[0] == 'characters') {
            // Get the ID part and remove any additional segments
            final idPart = pathSegments[1].split('/')[0];
            return int.parse(idPart);
          }
        }
        // If not a URL, treat as direct ID
        return int.parse(line);
      }).toList();

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de traitement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
