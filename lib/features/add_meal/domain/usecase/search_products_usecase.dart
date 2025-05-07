import 'package:active_fit/features/add_meal/data/repository/products_repository.dart';
import 'package:active_fit/features/add_meal/domain/entity/meal_entity.dart';

class SearchProductsUseCase {
  final ProductsRepository _productsRepository;

  SearchProductsUseCase(this._productsRepository);

  Future<List<MealEntity>> searchOFFProductsByString(
      String searchString) async {
    try {
      final products =
          await _productsRepository.getOFFProductsByString(searchString);
      return products;
    } catch (e) {
      print("Error in searchOFFProductsByString: $e");
      throw Exception("Error searching OFF products: $e");
    }
  }

  Future<List<MealEntity>> searchFoodByString(String searchString) async {
    try {
      final foods = await _productsRepository.getFoodByString(searchString);
      return foods;
    } catch (e) {
      print("Error in searchFoodByString: $e");
      throw Exception("Error searching foods: $e");
    }
  }
}
