import 'dart:convert';

import 'package:active_fit/features/add_meal/data/dto/fdc/fdc_word_response_dto.dart';
import 'package:logging/logging.dart';

import 'package:http/http.dart' as http;

import 'package:sentry_flutter/sentry_flutter.dart';

class FDCDataSource {
  static const _timeoutDuration = Duration(seconds: 10); // مهلة زمنية مناسبة
  final log = Logger('FDCDataSource');

  Future<FDCWordResponseDTO> fetchSearchWordResults(String searchString) async {
    final searchUrlString =
        'https://api.nal.usda.gov/fdc/v1/foods/search?query=$searchString&pageSize=20&dataType=Foundation%2CSR+Legacy&sortOrder=asc&api_key=b8VVpalFyiItel5SXX2qO8BtvfhxIy65QyGZhGgK';
    log.fine('Fetching FDC results from: $searchUrlString');

    try {
      final response =
          await http.get(Uri.parse(searchUrlString)).timeout(_timeoutDuration);
      log.fine('Response status code: ${response.statusCode}');
      log.fine('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['foods'] != null && jsonResponse['foods'] is List) {
          log.fine('Successful response from FDC');
          return FDCWordResponseDTO.fromJson(jsonResponse);
        } else {
          log.warning("'foods' field is null or not a list");
          return FDCWordResponseDTO(
              foods: [], totalHits: 0, currentPage: 0); // إرجاع قائمة فارغة
        }
      } else {
        log.severe("Failed to fetch data. Status code: ${response.statusCode}");
        throw Exception("Failed to fetch data from FDC API");
      }
    } catch (exception, stacktrace) {
      log.severe('Exception while getting FDC word search: $exception');
      Sentry.captureException(exception, stackTrace: stacktrace);
      throw Exception("Error fetching data from FDC API: $exception");
    }
  }
}
