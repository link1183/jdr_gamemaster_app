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
          StatContainer(
            borderColor: Colors.grey[300]!,
            child: CurrencyLabel(
              amount: character.currency.platinum,
              symbol: 'PP',
              color: Colors.grey[300]!,
            ),
          ),
          const SizedBox(width: 8),
          StatContainer(
            borderColor: Colors.yellow[600]!,
            child: CurrencyLabel(
              amount: character.currency.gold,
              symbol: 'GP',
              color: Colors.yellow[600]!,
            ),
          ),
          const SizedBox(width: 8),
          StatContainer(
            borderColor: Colors.blue[200]!,
            child: CurrencyLabel(
              amount: character.currency.electrum,
              symbol: 'EP',
              color: Colors.blue[200]!,
            ),
          ),
          const SizedBox(width: 8),
          StatContainer(
            borderColor: Colors.grey[400]!,
            child: CurrencyLabel(
              amount: character.currency.silver,
              symbol: 'SP',
              color: Colors.grey[400]!,
            ),
          ),
          const SizedBox(width: 8),
          StatContainer(
            borderColor: Colors.orange[300]!,
            child: CurrencyLabel(
              amount: character.currency.copper,
              symbol: 'CP',
              color: Colors.orange[300]!,
            ),
          ),
        ],
      ),
    );
  }
}
