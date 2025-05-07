import 'package:active_fit/features/add_meal/data/data_sources/edamam_data_source.dart';
import 'package:active_fit/features/add_meal/data/data_sources/off_data_source.dart';
import 'package:active_fit/features/add_meal/domain/entity/meal_entity.dart';
import 'package:active_fit/features/add_meal/domain/entity/meal_nutriments_entity.dart';

class ProductsRepository {
  final OFFDataSource _offDataSource;
  final EdamamDataSource _edamamDataSource;

  ProductsRepository(this._offDataSource, this._edamamDataSource);

  Future<List<MealEntity>> getOFFProductsByString(String searchString) async {
    final offWordResponse =
        await _offDataSource.fetchSearchWordResults(searchString);

    final products = offWordResponse.products
        .map((offProduct) => MealEntity.fromOFFProduct(offProduct))
        .toList();

    return products;
  }

  Future<List<MealEntity>> getFoodByString(String searchString) async {
    try {
      final foodResults = await _edamamDataSource.searchFood(searchString);

      return foodResults.map((result) {
        final food = result['food'];
        final nutrients = food['nutrients'];
        final servingInfo =
            food['servingSizes']?.first ?? {'quantity': 100, 'unit': 'g'};

        return MealEntity(
            code: food['foodId'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: food['label'] ?? 'Unknown',
            brands: food['brand'],
            url: food['uri'] ?? '',
            mealQuantity: "100",
            mealUnit: "g",
            servingQuantity:
                double.tryParse(servingInfo['quantity']?.toString() ?? "100"),
            servingUnit: servingInfo['unit'] ?? "g",
            servingSize: servingInfo['unit'] ?? "g",
            nutriments: MealNutrimentsEntity(
              energyKcal100: nutrients['ENERC_KCAL']?.toDouble(),
              carbohydrates100: nutrients['CHOCDF']?.toDouble(),
              fat100: nutrients['FAT']?.toDouble(),
              proteins100: nutrients['PROCNT']?.toDouble(),
              sugars100: nutrients['SUGAR']?.toDouble(),
              saturatedFat100: nutrients['FASAT']?.toDouble(),
              fiber100: nutrients['FIBTG']?.toDouble(),
            ),
            source: MealSourceEntity.custom);
      }).toList();
    } catch (e) {
      print("Error in getFoodByString: $e");
      throw Exception("Error searching foods: $e");
    }
  }

  Future<MealEntity> getOFFProductByBarcode(String barcode) async {
    final productResponse = await _offDataSource.fetchBarcodeResults(barcode);
    return MealEntity.fromOFFProduct(productResponse.product);
  }
}
