import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:core/src/features/products/models/item_model.dart';
import 'package:core/src/features/products/models/product_model.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part 'cart_model.g.dart';

@DataClass()
class CartModel with Identifiable, _$CartModel {
  @override
  final String id;
  final UserDto owner;
  final IList<UserDto> members;
  final bool isPublic;
  final String? title;

  const CartModel({
    required this.id,
    required this.owner,
    required this.members,
    required this.isPublic,
    required this.title,
  });

  static const String localId = '<local>';
  static const String temporaryId = '<temporary>';

  static const CartModel local = CartModel(
    id: CartModel.localId,
    owner: UserDto.unknown,
    members: IListConst([]),
    isPublic: false,
    title: null,
  );

  bool get isPrivate => !isPublic;

  String get displayTitle => title ?? 'Personal';

  bool isPersonal(String userId) => isPrivate && owner.id == userId;
}

@DataClass()
class CartItemModel extends ProductItem with Identifiable, _$CartItemModel {
  @override
  final String id;
  @override
  final ProductModel product;
  @override
  final int quantity;
  @override
  final IList<UserDto> buyers;
  @override
  final IList<IngredientDto> ingredientsRemoved;
  @override
  final IList<IngredientDto> ingredientsAdded;
  @override
  final IMap<LevelDto, double> levels;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.buyers,
    required this.ingredientsRemoved,
    required this.ingredientsAdded,
    required this.levels,
  });

  @override
  Fixed get totalCost =>
      quantity.toFixed() * ingredientsAdded.fold(product.price, (total, e) => total + e.price);
}
