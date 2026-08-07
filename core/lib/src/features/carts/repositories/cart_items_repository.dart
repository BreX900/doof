import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/carts/dto/cart_dto.dart';
import 'package:core/src/features/carts/repositories/carts_repository.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mekart/mekart.dart';

class CartItemsRepository {
  static CartItemsRepository get instance => CartItemsRepository._();
  static const String collection = 'products';

  FirebaseFirestore get _firestore => Instances.firestore;

  CartItemsRepository._();

  CollectionReference<CartItemDto> _ref(String cartId) => _firestore
      .collection(CartsRepository.collection)
      .doc(cartId)
      .collection(collection)
      .withJsonConverter(CartItemDto.fromJson);

  Future<IList<CartItemDto>> fetchAll(String cartId) async {
    final snapshot = await _ref(cartId).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }

  Future<void> upsert(String cartId, CartItemDto item) async {
    await _ref(cartId).doc(item.id.nullIfEmpty).set(item);
  }

  Future<void> remove(String cartId, String cartProductId) async {
    await _ref(cartId).doc(cartProductId).delete();
  }
}
