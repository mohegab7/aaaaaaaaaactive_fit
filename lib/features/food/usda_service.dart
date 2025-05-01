import 'dart:convert';
import 'package:active_fit/features/food/others/food.dart';
import 'package:http/http.dart' as http;


class UsdaService {
  static const String _apiKey = 'b8VVpalFyiItel5SXX2qO8BtvfhxIy65QyGZhGgK';
  static const String _baseUrl = 'https://api.nal.usda.gov/fdc/v1/foods/search';

  Future<List<Food>> searchFoods(
    String query, {
    Map<String, dynamic>? filters,
    int page = 1,
  }) async {
    final Map<String, String> params = {
      'api_key': _apiKey,
      'query': query,
      'pageSize': '20',
      'pageNumber': page.toString(),
    };

    if (filters != null) {
      // تحويل جميع القيم إلى String
      filters.forEach((key, value) {
        if (value != null) {
          params[key] = value.toString();
        }
      });
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['foods'] as List).map((f) => Food.fromJson(f)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Exception _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return Exception('Bad request');
      case 401:
        return Exception('API key invalid');
      case 404:
        return Exception('Not found');
      case 429:
        return Exception('Rate limit exceeded');
      case 500:
        return Exception('Server error');
      default:
        return Exception('Failed with status: ${response.statusCode}');
    }
  }
}