import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jdr_gamemaster_app/services/logging_service.dart';
import 'package:logging/logging.dart';

class CharacterService {
  static final Logger _logger = LoggingService().getLogger("CharacterService");
  static const int _retryCount = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  static Future<Map<String, dynamic>> fetchCharacterData(
      int characterId) async {
    final String url =
        'https://character-service.dndbeyond.com/character/v5/character/$characterId';

    for (int attempt = 1; attempt <= _retryCount; attempt++) {
      try {
        _logger.info('Fetching character data (Attempt $attempt): $url');
        final http.Response response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          _logger.info('Character data fetched successfully');
          return jsonDecode(response.body);
        } else {
          _logger.warning(
              'Failed to load character data: HTTP ${response.statusCode}');
          throw Exception(
              'Failed to load character data: HTTP ${response.statusCode}');
        }
      } on http.ClientException catch (e) {
        _logger
            .warning('Network issue during attempt $attempt: $e. Retrying...');
      } on TimeoutException catch (e) {
        _logger.warning(
            'Request timeout during attempt $attempt: $e. Retrying...');
      } catch (e) {
        _logger.severe('Unexpected error: $e');
        throw Exception('Error fetching character data: $e');
      }

      if (attempt < _retryCount) {
        await Future<dynamic>.delayed(_retryDelay);
      }
    }

    final String errorMessage =
        'Failed to fetch character data after $_retryCount attempts';
    _logger.severe(errorMessage);
    throw Exception(errorMessage);
  }
}
