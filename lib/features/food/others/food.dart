class Food {
  final int fdcId;
  final String description;
  final String dataType;
  final String? brandOwner;
  final String? ingredients;
  final List<Nutrient> foodNutrients;

  Food({
    required this.fdcId,
    required this.description,
    required this.dataType,
    this.brandOwner,
    this.ingredients,
    required this.foodNutrients,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      fdcId: json['fdcId'],
      description: json['description'],
      dataType: json['dataType'] ?? 'Unknown',
      brandOwner: json['brandOwner'],
      ingredients: json['ingredients'],
      foodNutrients: (json['foodNutrients'] as List)
          .map((n) => Nutrient.fromJson(n))
          .toList(),
    );
  }

  double? getNutrientValue(String nutrientName) {
    try {
      return foodNutrients
          .firstWhere((n) => n.nutrientName.toLowerCase().contains(nutrientName.toLowerCase()))
          .value;
    } catch (e) {
      return null;
    }
  }
}

class Nutrient {
  final String nutrientName;
  final double value;
  final String unitName;

  Nutrient({
    required this.nutrientName,
    required this.value,
    required this.unitName,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      nutrientName: json['nutrientName'] ?? 'Unknown',
      value: (json['value'] ?? 0).toDouble(),
      unitName: json['unitName'] ?? '',
    );
  }
}