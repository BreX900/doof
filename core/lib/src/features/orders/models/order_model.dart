import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:core/src/features/orders/dto/order_dto.dart';
import 'package:core/src/features/products/models/item_model.dart';
import 'package:core/src/features/products/models/product_model.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'order_model.g.dart';

@DataClass()
class OrderModel with Identifiable, _$OrderModel {
  @override
  final String id;
  final String? originCartId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserDto payer;
  final IList<UserDto> members;
  final bool shippable;
  final OrderStatus status;
  final String? place;
  final Decimal payedAmount;

  const OrderModel({
    required this.id,
    required this.originCartId,
    required this.createdAt,
    required this.updatedAt,
    required this.payer,
    required this.members,
    required this.shippable,
    required this.status,
    required this.place,
    required this.payedAmount,
  });
}

@DataClass()
class OrderItemModel extends ProductItem with Identifiable, _$OrderItemModel {
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

  final Decimal payedAmount;

  OrderItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.buyers,
    required this.ingredientsRemoved,
    required this.ingredientsAdded,
    required this.levels,
    required this.payedAmount,
  });

  @override
  Decimal get totalCost => payedAmount;
}
