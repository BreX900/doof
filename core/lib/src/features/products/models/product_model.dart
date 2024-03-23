import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/categories/dto/category_dto.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'product_model.g.dart';

@DataClass()
class ProductModel with Identifiable, _$ProductModel {
  @override
  final String id;
  final CategoryDto category;

  final String? imageUrl;
  final String title;
  final String description;
  final Decimal price;

  final IList<IngredientDto> ingredients;
  final IList<IngredientDto> removableIngredients;
  final IList<IngredientDto> addableIngredients;
  final IList<LevelDto> levels;

  ProductModel({
    required this.id,
    required this.category,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.ingredients,
    required this.removableIngredients,
    required this.addableIngredients,
    required this.levels,
  });
}
