import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jdr_gamemaster_app/services/logging_service.dart';
import 'package:logging/logging.dart';

class CharacterService {
  static final Logger _logger = LoggingService().getLogger("CharacterService");

  static Future<Map<String, dynamic>> fetchCharacterData(
      int characterId) async {
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
      _logger.severe('Error fetching character data', e);
      throw Exception('Error fetching character data: $e');
    }
  }
}
