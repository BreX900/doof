import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part 'addition_dto.g.dart';

typedef IngredientDtoFields = _$IngredientDtoJsonKeys;

@DataClass()
@DtoSerializable(createJsonKeys: true)
class IngredientDto with Identifiable, _$IngredientDto {
  @override
  final String id;
  final String title;
  final String description;

  final Fixed price;

  const IngredientDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory IngredientDto.fromJson(Map<String, dynamic> map) => _$IngredientDtoFromJson(map);

  Map<String, dynamic> toJson() => _$IngredientDtoToJson(this);
}
