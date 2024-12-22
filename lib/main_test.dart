import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jdr_gamemaster_app/models/character.dart';

Future<Map<String, dynamic>> fetchCharacterData(String characterId) async {
  final url =
      'https://character-service.dndbeyond.com/character/v5/character/$characterId';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load character data: HTTP ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching character data: $e');
  }
}

Future<void> main() async {
  Map<String, int> characters = {
    '133116028': 16, // Selenna
    '132627929': 21, // Lorakk
    '133113999': 21, // Facilier
    '132588957': 18, // Merlin
    '138231200': 15 // Hikari
  };
  List<Future<void>> futures = characters.entries.map((character) async {
    Map<String, dynamic> characterJson =
        await fetchCharacterData(character.key);
    Character c = Character.fromJson(characterJson);
    //int totalAc = c.calculateArmorClass();
    //print('Expected AC: ${character.value}');
    //print('Calculation matches expected: ${totalAc == character.value}');
    //print('==================\n');

    print("${c.name}: ${c.currentHealth}/${c.maxHealth}");
  }).toList();

  await Future.wait(futures);
}
