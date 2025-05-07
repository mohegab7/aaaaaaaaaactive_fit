import 'package:json_annotation/json_annotation.dart';

part 'fdc_food_nutriment_dto.g.dart';

@JsonSerializable()
class FDCFoodNutrimentDTO {
  final int? id;

  @JsonKey(name: 'nutrient')
  final Map<String, dynamic>? nutrientData;

  final double? amount;

  int? get nutrientId => nutrientData?['id'] as int?;
  String? get name => nutrientData?['name'] as String?;

  FDCFoodNutrimentDTO({
    this.id,
    this.nutrientData,
    required this.amount,
  });

  factory FDCFoodNutrimentDTO.fromJson(Map<String, dynamic> json) {
    return FDCFoodNutrimentDTO(
      id: json['id'] as int?,
      nutrientData: json['nutrient'] as Map<String, dynamic>?,
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nutrient': nutrientData,
        'amount': amount,
      };
}
