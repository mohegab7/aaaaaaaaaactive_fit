import 'package:active_fit/features/add_meal/data/dto/fdc_sp/sp_const.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sp_fdc_portion_dto.g.dart';

@JsonSerializable()
class SpFdcPortionDTO {
  final double? amount;
  @JsonKey(name: SPConst.fdcPortionsMeasureUnitId)
  final int? measureUnitId;
  @JsonKey(name: SPConst.fdcPortionsGramWeight)
  final double? gramWeight;

  SpFdcPortionDTO(
      {required this.amount,
      required this.measureUnitId,
      required this.gramWeight});

  factory SpFdcPortionDTO.fromJson(Map<String, dynamic> json) =>
      _$SpFdcPortionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SpFdcPortionDTOToJson(this);
}
