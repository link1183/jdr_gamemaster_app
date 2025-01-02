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
