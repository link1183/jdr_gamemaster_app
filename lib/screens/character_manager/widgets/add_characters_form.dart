import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
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

      final ids = <int>[];
      for (final line in inputLines) {
        try {
          if (line.startsWith('https://www.dndbeyond.com/characters/')) {
            final uri = Uri.parse(line);
            if (uri.pathSegments.length < 2 ||
                uri.pathSegments[0] != 'characters') {
              throw FormatException('URL invalide: $line');
            }
            final idPart = uri.pathSegments[1].split('/')[0];
            ids.add(int.parse(idPart));
          } else {
            ids.add(int.parse(line));
          }
        } catch (e) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            title: const Text("Erreur de format"),
            description: Text("Ligne invalide: $line"),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 4),
            boxShadow: highModeShadow,
            showProgressBar: false,
            closeOnClick: true,
            applyBlurEffect: true,
          );
          return;
        }
      }

      if (ids.isEmpty) {
        toastification.show(
          context: context,
          type: ToastificationType.warning,
          style: ToastificationStyle.flatColored,
          title: const Text("Attention"),
          description: const Text("Aucun ID valide trouvé"),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 4),
          boxShadow: highModeShadow,
          showProgressBar: false,
          closeOnClick: true,
          applyBlurEffect: true,
        );
        return;
      }

      final results = <int, bool>{};
      for (final id in ids) {
        try {
          results[id] = await Provider.of<AppState>(context, listen: false)
              .addCharacter(id, context);
        } catch (e) {
          if (!mounted) return;
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            title: const Text("Erreur d'ajout"),
            description: Text("Impossible d'ajouter l'ID $id: $e"),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 4),
            boxShadow: highModeShadow,
            showProgressBar: false,
            closeOnClick: true,
            applyBlurEffect: true,
          );
        }
      }

      if (mounted) {
        final successful = results.values.where((v) => v).length;
        final failed = results.values.where((v) => !v).length;

        toastification.show(
          context: context,
          type: failed == 0
              ? ToastificationType.success
              : ToastificationType.warning,
          style: ToastificationStyle.flatColored,
          title: Text(failed == 0 ? "Succès" : "Résultats mixtes"),
          description: Text('$successful ajoutés, $failed échecs'),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 4),
          boxShadow: highModeShadow,
          showProgressBar: false,
          closeOnClick: true,
          applyBlurEffect: true,
        );
        _textController.clear();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: const Text("Erreur inattendue"),
          description: Text(e.toString()),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 4),
          boxShadow: highModeShadow,
          showProgressBar: false,
          closeOnClick: true,
          applyBlurEffect: true,
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
