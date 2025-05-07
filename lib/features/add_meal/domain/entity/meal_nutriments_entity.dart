import 'package:active_fit/core/data/dbo/meal_nutriments_dbo.dart';
import 'package:active_fit/core/utils/extensions.dart';
import 'package:active_fit/features/add_meal/data/dto/fdc/fdc_const.dart';
import 'package:active_fit/features/add_meal/data/dto/fdc/fdc_food_nutriment_dto.dart';
import 'package:active_fit/features/add_meal/data/dto/off/off_product_nutriments_dto.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class MealNutrimentsEntity extends Equatable {
  final double? energyKcal100;

  final double? carbohydrates100;
  final double? fat100;
  final double? proteins100;
  final double? sugars100;
  final double? saturatedFat100;
  final double? fiber100;

  double? get energyPerUnit => _getValuePerUnit(energyKcal100);

  double? get carbohydratesPerUnit => _getValuePerUnit(carbohydrates100);

  double? get fatPerUnit => _getValuePerUnit(fat100);

  double? get proteinsPerUnit => _getValuePerUnit(proteins100);

  const MealNutrimentsEntity(
      {required this.energyKcal100,
      required this.carbohydrates100,
      required this.fat100,
      required this.proteins100,
      required this.sugars100,
      required this.saturatedFat100,
      required this.fiber100});

  double? getNutrientValue(String nutrientName) {
    switch (nutrientName.toLowerCase()) {
      case 'energy':
      case 'calories':
        return energyKcal100;
      case 'protein':
        return proteins100;
      case 'carbohydrate':
      case 'carbs':
        return carbohydrates100;
      case 'total lipid (fat)':
      case 'fat':
        return fat100;
      case 'sugars':
        return sugars100;
      case 'saturated fat':
        return saturatedFat100;
      case 'fiber':
      case 'dietary fiber':
        return fiber100;
      default:
        return null;
    }
  }

  factory MealNutrimentsEntity.empty() => const MealNutrimentsEntity(
      energyKcal100: null,
      carbohydrates100: null,
      fat100: null,
      proteins100: null,
      sugars100: null,
      saturatedFat100: null,
      fiber100: null);

  factory MealNutrimentsEntity.fromMealNutrimentsDBO(
      MealNutrimentsDBO nutriments) {
    return MealNutrimentsEntity(
        energyKcal100: nutriments.energyKcal100,
        carbohydrates100: nutriments.carbohydrates100,
        fat100: nutriments.fat100,
        proteins100: nutriments.proteins100,
        sugars100: nutriments.sugars100,
        saturatedFat100: nutriments.saturatedFat100,
        fiber100: nutriments.fiber100);
  }

  factory MealNutrimentsEntity.fromOffNutriments(
      OFFProductNutrimentsDTO offNutriments) {
    // 1. OFF product nutriments can either be String, int, double or null
    // 2. Extension function asDoubleOrNull does not work on a dynamic data
    // type, so cast to it Object?
    return MealNutrimentsEntity(
        energyKcal100:
            (offNutriments.energy_kcal_100g as Object?)?.asDoubleOrNull(),
        carbohydrates100:
            (offNutriments.carbohydrates_100g as Object?).asDoubleOrNull(),
        fat100: (offNutriments.fat_100g as Object?).asDoubleOrNull(),
        proteins100: (offNutriments.proteins_100g as Object?).asDoubleOrNull(),
        sugars100: (offNutriments.sugars_100g as Object?).asDoubleOrNull(),
        saturatedFat100:
            (offNutriments.saturated_fat_100g as Object?).asDoubleOrNull(),
        fiber100: (offNutriments.fiber_100g as Object?).asDoubleOrNull());
  }

  factory MealNutrimentsEntity.fromFDCNutriments(
      List<FDCFoodNutrimentDTO> fdcNutriment) {
    print("===== Starting Nutrient Mapping =====");
    print("Total nutrients received: ${fdcNutriment.length}");

    // Get nutrient by ID or try to find by name if ID doesn't match
    double? findNutrientAmount(
        List<int> nutrientIds, List<String> nutrientNames) {
      print(
          "\nLooking for nutrient with IDs: $nutrientIds or names: $nutrientNames");

      var nutrient = fdcNutriment.firstWhereOrNull((n) {
        print(
            "Checking nutrient - ID: ${n.nutrientId}, Name: ${n.name}, Amount: ${n.amount}");
        return n.nutrientId != null && nutrientIds.contains(n.nutrientId);
      });

      if (nutrient == null && nutrientNames.isNotEmpty) {
        print("No match by ID, trying to match by name...");
        nutrient = fdcNutriment.firstWhereOrNull((n) {
          if (n.name == null) return false;
          final matches = nutrientNames.any(
              (name) => n.name!.toLowerCase().contains(name.toLowerCase()));
          print("Checking name match: ${n.name} - Matches: $matches");
          return matches;
        });
      }

      if (nutrient != null) {
        print("Found matching nutrient - Amount: ${nutrient.amount}");
      } else {
        print("No matching nutrient found");
      }

      return nutrient?.amount;
    }

    final energyTotal = findNutrientAmount([
          FDCConst.fdcTotalKcalId,
          FDCConst.fdcKcalAtwaterGeneralId,
          FDCConst.fdcKcalAtwaterSpecificId
        ], [
          'energy',
          'calories',
          'kcal'
        ]) ??
        0.0;

    final carbsTotal = findNutrientAmount(
            [FDCConst.fdcTotalCarbsId], ['carbohydrate', 'carbs']) ??
        0.0;

    final fatTotal =
        findNutrientAmount([FDCConst.fdcTotalFatId], ['fat', 'total lipids']) ??
            0.0;

    final proteinsTotal =
        findNutrientAmount([FDCConst.fdcTotalProteinsId], ['protein']) ?? 0.0;

    final sugarTotal = findNutrientAmount(
            [FDCConst.fdcTotalSugarId], ['sugars', 'total sugars']) ??
        0.0;

    final saturatedFatTotal = findNutrientAmount(
            [FDCConst.fdcTotalSaturatedFatId],
            ['saturated fat', 'saturated fatty acids']) ??
        0.0;

    final fiberTotal = findNutrientAmount(
            [FDCConst.fdcTotalDietaryFiberId], ['fiber', 'dietary fiber']) ??
        0.0;

    print("\n===== Final Mapped Values =====");
    print("Energy: $energyTotal");
    print("Carbs: $carbsTotal");
    print("Fat: $fatTotal");
    print("Proteins: $proteinsTotal");
    print("Sugar: $sugarTotal");
    print("Saturated Fat: $saturatedFatTotal");
    print("Fiber: $fiberTotal");

    return MealNutrimentsEntity(
        energyKcal100: energyTotal,
        carbohydrates100: carbsTotal,
        fat100: fatTotal,
        proteins100: proteinsTotal,
        sugars100: sugarTotal,
        saturatedFat100: saturatedFatTotal,
        fiber100: fiberTotal);
  }

  static double? _getValuePerUnit(double? valuePer100) {
    if (valuePer100 != null) {
      return valuePer100 / 100;
    } else {
      return null;
    }
  }

  @override
  List<Object?> get props =>
      [energyKcal100, carbohydrates100, fat100, proteins100];
}
