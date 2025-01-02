import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../models/app_state.dart';

class CharacterIdActions extends StatefulWidget {
  final int id;

  const CharacterIdActions({required this.id, super.key});

  @override
  State<CharacterIdActions> createState() => _CharacterIdActionsState();
}

class _CharacterIdActionsState extends State<CharacterIdActions>
    with TickerProviderStateMixin {
  final Map<int, AnimationController> _fadeControllers = {};
  int? _copiedId;

  @override
  void dispose() {
    for (var controller in _fadeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.id.toString()));
    _fadeControllers[widget.id]?.dispose();

    final controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeControllers[widget.id] = controller;

    controller.forward();
    setState(() => _copiedId = widget.id);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        controller.reverse().then((_) {
          if (mounted) {
            setState(() => _copiedId = null);
            _fadeControllers[widget.id]?.dispose();
            _fadeControllers.remove(widget.id);
          }
        });
      }
    });
  }

  void _handleEdit() async {
    final controller = TextEditingController(text: widget.id.toString());
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier l\'ID'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nouvel ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final newId = int.tryParse(controller.text);
              if (newId != null) {
                final appState = Provider.of<AppState>(context, listen: false);
                if (await appState.editCharacter(widget.id, newId)) {
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('ID modifié avec succès'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(
                          'Une erreur s\'est produite. Merci de contacter Adrien pour la résolution de celle-ci.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                navigator.pop();
              }
            },
            child: const Text('Sauvegarder'),
          )
        ],
      ),
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: _handleCopy,
              ),
              if (_copiedId == widget.id && _fadeControllers[widget.id] != null)
                Positioned(
                  right: -12,
                  top: 12,
                  child: FadeTransition(
                    opacity: _fadeControllers[widget.id]!,
                    child: const Text('Copié',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 16),
          onPressed: _handleEdit,
        ),
      ],
    );
  }
}
