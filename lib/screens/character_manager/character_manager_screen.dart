import 'package:flutter/material.dart';
import 'widgets/add_characters_form.dart';
import 'widgets/character_list.dart';

class CharacterManagerScreen extends StatefulWidget {
  const CharacterManagerScreen({super.key});

  @override
  State<CharacterManagerScreen> createState() => _CharacterManagerScreenState();
}

class _CharacterManagerScreenState extends State<CharacterManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des personnages'),
      ),
      body: const Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              AddCharactersForm(),
              Expanded(child: CharacterList()),
            ],
          ),
        ],
      ),
    );
  }
}
