import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'order_addition_dto.g.dart';

@DataClass()
@DtoSerializable()
class OrderIngredientDto with _$OrderIngredientDto {
  final IngredientDto ingredient;

  /// `true`: added & `false`: removed
  final bool value;

  const OrderIngredientDto({
    required this.ingredient,
    required this.value,
  });
  factory OrderIngredientDto.fromJson(Map<String, dynamic> map) =>
      _$OrderIngredientDtoFromJson(map);
  Map<String, dynamic> toJson() => _$OrderIngredientDtoToJson(this);
}
