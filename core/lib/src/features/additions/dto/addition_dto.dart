import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'addition_dto.g.dart';

@DataClass(createFieldsClass: true)
@DtoSerializable()
class IngredientDto with Identifiable, _$IngredientDto {
  static const fields = _IngredientDtoFields();

  @override
  final String id;
  final String title;
  final String description;

  final Decimal price;

  const IngredientDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory IngredientDto.fromJson(Map<String, dynamic> map) => _$IngredientDtoFromJson(map);
  Map<String, dynamic> toJson() => _$IngredientDtoToJson(this);
}
