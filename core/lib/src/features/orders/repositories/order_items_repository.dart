import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:core/src/features/orders/dto/order_addition_dto.dart';
import 'package:core/src/features/orders/dto/order_ingredient_dto.dart';
import 'package:core/src/features/orders/dto/order_item_dto.dart';
import 'package:core/src/features/orders/repositories/orders_repository.dart';
import 'package:core/src/features/products/dto/product_dto.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/shared/instances.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mekart/mekart.dart';

class OrderItemsRepository {
  static OrderItemsRepository get instance => OrderItemsRepository._();
  static const String collection = 'products';

  FirebaseFirestore get _firestore => Instances.firestore;

  OrderItemsRepository._();

  CollectionReference<OrderItemDto> _ref(String orderId) => _firestore
      .collection(OrdersRepository.collection)
      .doc(orderId)
      .collection(collection)
      .withJsonConverter(OrderItemDto.fromJson);

  Future<void> create(
    String orderId, {
    required IList<UserDto> buyers,
    required ProductDto product,
    required int quantity,
    required IList<IngredientDto> ingredientsRemoved,
    required IList<IngredientDto> ingredientsAdded,
    required IMap<LevelDto, double> levels,
    required Decimal payedAmount,
  }) async {
    await _ref(orderId).add(OrderItemDto(
      id: '',
      createdAt: DateTime.now(),
      buyers: buyers.map((e) => e.id).toIList(),
      product: product,
      quantity: quantity,
      ingredients: [
        ...ingredientsRemoved.map((ingredient) {
          return OrderIngredientDto(ingredient: ingredient, value: false);
        }),
        ...ingredientsAdded.map((ingredient) {
          return OrderIngredientDto(ingredient: ingredient, value: true);
        }),
      ].toIList(),
      levels: levels.entries.mapTo((ingredient, value) {
        return OrderLevelDto(level: ingredient, value: value);
      }).toIList(),
      payedAmount: payedAmount,
    ));
  }

  Future<void> delete(String orderId, String productId) async {
    await _ref(orderId).doc(productId).delete();
  }

  Future<IList<OrderItemDto>> fetchAll(String orderId) async {
    final snapshot = await _ref(orderId).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }
}
