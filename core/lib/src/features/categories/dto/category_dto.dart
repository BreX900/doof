import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'category_dto.g.dart';

@DataClass(createFieldsClass: true)
@DtoSerializable()
class CategoryDto with Identifiable, _$CategoryDto implements Comparable<CategoryDto> {
  static const fields = _CategoryDtoFields();

  @override
  final String id;
  final int weight;

  final String title;

  const CategoryDto({
    required this.id,
    required this.weight,
    required this.title,
  });

  @override
  int compareTo(CategoryDto other) => weight.compareTo(other.weight);

  factory CategoryDto.fromJson(Map<String, dynamic> map) => _$CategoryDtoFromJson(map);
  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
