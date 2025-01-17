import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../../models/app_state.dart';

class CharacterIdActions extends StatefulWidget {
  final int id;

  const CharacterIdActions({required this.id, super.key});

  @override
  State<CharacterIdActions> createState() => _CharacterIdActionsState();
}

class _CharacterIdActionsState extends State<CharacterIdActions>
    with TickerProviderStateMixin<CharacterIdActions> {
  final Map<int, AnimationController> _fadeControllers =
      <int, AnimationController>{};
  int? _copiedId;

  @override
  void dispose() {
    for (AnimationController controller in _fadeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.id.toString()));
    _fadeControllers[widget.id]?.dispose();

    final AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeControllers[widget.id] = controller;

    controller.forward();
    setState(() => _copiedId = widget.id);

    Future<Null>.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        controller.reverse().then<Null>((void _) {
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
    final TextEditingController controller =
        TextEditingController(text: widget.id.toString());
    final NavigatorState navigator = Navigator.of(context);

    showDialog<dynamic>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Modifier l\'ID'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nouvel ID'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop<Object?>(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final int? newId = int.tryParse(controller.text);
              if (newId != null) {
                final AppState appState =
                    Provider.of<AppState>(context, listen: false);
                if (await appState.editCharacter(widget.id, newId)) {
                  if (mounted) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.success,
                      style: ToastificationStyle.flatColored,
                      title: const Text("Succès"),
                      description:
                          const Text("L'ID a été modifié avec succès."),
                      alignment: Alignment.topRight,
                      autoCloseDuration: const Duration(seconds: 4),
                      boxShadow: highModeShadow,
                      showProgressBar: false,
                      closeOnClick: true,
                      applyBlurEffect: true,
                    );
                  }
                } else {
                  if (mounted) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.error,
                      style: ToastificationStyle.flatColored,
                      title: const Text("Une erreur s'est produite"),
                      description: const Text(
                          "Merci de contacter Adrien pour la résolution de celle-ci."),
                      alignment: Alignment.topRight,
                      autoCloseDuration: const Duration(seconds: 4),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: lowModeShadow,
                      showProgressBar: false,
                      closeOnClick: true,
                      applyBlurEffect: true,
                    );
                  }
                }
                navigator.pop<Object?>();
              }
            },
            child: const Text('Sauvegarder'),
          )
        ],
      ),
    ).then<void>((dynamic _) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
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
