import 'package:flutter/material.dart';
import '../../../../models/character.dart';
import '../shared/stat_containers.dart';

class CharacterCurrencies extends StatelessWidget {
  final Character character;

  const CharacterCurrencies({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          _buildCurrencyItem(
              character.currency.platinum, 'PP', Colors.grey[300]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              character.currency.gold, 'GP', Colors.yellow[600]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              character.currency.electrum, 'EP', Colors.blue[200]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              character.currency.silver, 'SP', Colors.grey[400]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              character.currency.copper, 'CP', Colors.orange[300]!),
        ],
      ),
    );
  }

  String _getCurrencyDescription(String symbol) {
    switch (symbol) {
      case 'PP':
        return 'Pièces de Platine (Platinum)\n1 PP = 10 GP';
      case 'GP':
        return 'Pièces d\'Or (Gold)\n1 GP = 2 EP';
      case 'EP':
        return 'Pièces d\'Electrum (Electrum)\n1 GP = 2 EP';
      case 'SP':
        return 'Pièces d\'Argent (Silver)\n1 GP = 10 SP';
      case 'CP':
        return 'Pièces de Cuivre (Copper)\n1 SP = 10 CP';
      default:
        return symbol;
    }
  }

  Widget _buildCurrencyItem(int amount, String symbol, Color color) {
    return Tooltip(
      message: _getCurrencyDescription(symbol),
      child: StatContainer(
        borderColor: color,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount.toString(),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              symbol,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
