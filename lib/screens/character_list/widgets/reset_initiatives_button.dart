import 'package:flutter/material.dart';

class ResetInitiativesButton extends StatelessWidget {
  final VoidCallback onReset;

  const ResetInitiativesButton({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: TextButton.icon(
        icon: const Icon(Icons.restart_alt),
        label: const Text('Réinitialiser les initiatives'),
        onPressed: () {
          onReset();
        },
      ),
    );
  }
}
