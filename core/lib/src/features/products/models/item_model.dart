import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:core/src/features/products/models/product_model.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mekart/mekart.dart';

abstract class ProductItem {
  ProductModel get product;

  int get quantity;

  IList<UserDto> get buyers;

  IList<IngredientDto> get ingredientsRemoved;

  IList<IngredientDto> get ingredientsAdded;

  IMap<LevelDto, double> get levels;

  Fixed get totalCost;

  Fixed get individualCost => totalCost / buyers.length.toFixed();
}
