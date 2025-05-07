import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class EdamamDataSource {
  static const _timeoutDuration = Duration(seconds: 10);
  final log = Logger('EdamamDataSource');

  final String appId = "67d045a0";
  final String appKey = "bc7f8881c24b194298de52ca0668165b";

  Future<List<Map<String, dynamic>>> searchFood(String searchString) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              "https://api.edamam.com/api/food-database/v2/parser?ingr=${Uri.encodeComponent(searchString)}&app_id=$appId&app_key=$appKey",
            ),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["hints"] != null && data["hints"].isNotEmpty) {
          return List<Map<String, dynamic>>.from(data["hints"]);
        } else {
          log.warning("No results found for search: $searchString");
          return [];
        }
      } else {
        log.severe("Failed to fetch data. Status code: ${response.statusCode}");
        throw Exception("Failed to fetch data from Edamam API");
      }
    } catch (exception, stacktrace) {
      log.severe('Exception while searching Edamam: $exception');
      Sentry.captureException(exception, stackTrace: stacktrace);
      throw Exception("Error fetching data from Edamam API: $exception");
    }
  }
}
