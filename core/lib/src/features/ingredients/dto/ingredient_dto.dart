import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'ingredient_dto.g.dart';

typedef LevelDtoFields = _$LevelDtoJsonKeys;

/// Examples:
/// [min] <= [initial] <= [max] | [offset] ([initialOffset])
/// 0 <= 2 <= 5 => 5 (0.4)
/// 1 <= 2 <= 5 => 4 (0.5)
@DataClass()
@DtoSerializable(createJsonKeys: true)
class LevelDto with Identifiable, _$LevelDto {
  @override
  final String id;
  final String title;
  final String description;
  final int min;
  final int initial;
  final int max;

  const LevelDto({
    required this.id,
    required this.title,
    required this.description,
    required this.min,
    required int? initial,
    required this.max,
  })  : initial = initial ?? min,
        assert(min < max, 'Min $min is lower than max $max.'),
        assert(initial == null || (initial >= min && initial <= max),
            'Initial $initial is not on min $min and max $max range.');

  int get offset => max - min;
  double get initialOffset => (initial - min) / offset;

  int calculateByOffset(double value) => (offset * value).toInt();

  factory LevelDto.fromJson(Map<String, dynamic> map) => _$LevelDtoFromJson(map);
  Map<String, dynamic> toJson() => _$LevelDtoToJson(this);
}
