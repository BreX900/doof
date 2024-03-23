import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'order_ingredient_dto.g.dart';

@DataClass()
@DtoSerializable()
class OrderLevelDto with _$OrderLevelDto {
  final LevelDto level;
  final double value;

  const OrderLevelDto({
    required this.level,
    required this.value,
  });

  int get effectiveValue => (level.offset * value).toInt();

  factory OrderLevelDto.fromJson(Map<String, dynamic> map) => _$OrderLevelDtoFromJson(map);
  Map<String, dynamic> toJson() => _$OrderLevelDtoToJson(this);
}
