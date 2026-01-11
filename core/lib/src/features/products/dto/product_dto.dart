import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part 'product_dto.g.dart';

typedef ProductDtoFields = _$ProductDtoJsonKeys;

@DataClass()
@DtoSerializable(createJsonKeys: true)
class ProductDto with Identifiable, _$ProductDto {
  @override
  final String id;

  final String categoryId;
  final String? imageUrl;
  final String title;
  final String description;

  final Fixed price;
  final IList<String> ingredients;
  final IList<String> removableIngredients;
  final IList<String> addableIngredients;
  final IList<String> levels;

  const ProductDto({
    required this.id,
    required this.categoryId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.ingredients,
    required this.removableIngredients,
    required this.addableIngredients,
    required this.levels,
  });

  factory ProductDto.fromJson(Map<String, dynamic> map) => _$ProductDtoFromJson(map);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
