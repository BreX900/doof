import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firebase_auth_extensions.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/carts/dto/cart_dto.dart';
import 'package:core/src/features/carts/repositories/carts_repository.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mekart/mekart.dart';
import 'package:rxdart/rxdart.dart';

class CartItemsRepository {
  static CartItemsRepository get instance => CartItemsRepository._();
  static const String collection = 'products';

  FirebaseAuth get _auth => Instances.auth;
  FirebaseFirestore get _firestore => Instances.firestore;

  CartItemsRepository._();

  CollectionReference<CartItemDto> _ref(String cartId) => _firestore
      .collection(CartsRepository.collection)
      .doc(cartId)
      .collection(collection)
      .withJsonConverter(CartItemDto.fromJson);

  Stream<IList<CartItemDto>> watchAll(String cartId) {
    return _ref(cartId)
        .snapshots()
        .takeUntil(_auth.userLogged)
        .map((event) => event.docs.map((e) => e.data()).toIList());
  }

  Future<void> upsert(String cartId, CartItemDto item) async {
    await _ref(cartId).doc(item.id.nullIfEmpty).set(item);
  }

  Future<void> remove(String cartId, String cartProductId) async {
    await _ref(cartId).doc(cartProductId).delete();
  }
}
