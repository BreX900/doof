import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firebase_auth_extensions.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/carts/dto/cart_dto.dart';
import 'package:core/src/features/organizations/repositories/organizations_repository.dart';
import 'package:core/src/shared/data/failure.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mekart/mekart.dart';
import 'package:rxdart/rxdart.dart';

class CartsRepository {
  static CartsRepository get instance => CartsRepository._();
  static const String collection = 'carts';

  FirebaseAuth get _auth => Instances.auth;
  FirebaseFirestore get _firestore => Instances.firestore;

  CartsRepository._();

  CollectionReference<CartDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(CartDto.fromJson);

  Stream<CartDto> watch(String organizationId, String cartId) {
    final ref = _ref(organizationId).doc(cartId);
    return ref.snapshots().map((snapshot) {
      final cart = snapshot.data();
      if (cart == null) throw TargetNotFoundFailure(ref.path);
      return cart;
    });
  }

  Future<CartDto?> fetchPersonal(String organizationId, {required String userId}) async {
    final snapshot = await _ref(organizationId)
        .where(CartDtoFields.membersIds, arrayContains: userId)
        .where(CartDtoFields.isPublic, isEqualTo: false)
        .get();
    return snapshot.docs.oneOrNull?.data();
  }

  Stream<IList<CartDto>> watchAll(String organizationId, {required String userId}) {
    return _ref(organizationId)
        .where(CartDtoFields.membersIds, arrayContains: userId)
        .orderBy(CartDtoFields.title)
        .snapshots()
        .takeUntil(_auth.userLogged)
        .map((event) => event.docs.map((e) => e.data()).toIList());
  }

  Future<String> create(
    String organizationId, {
    required bool isPublic,
    required String? title,
  }) async {
    final userId = _auth.currentUser!.uid;
    final ref = await _ref(organizationId).add(CartDto(
      id: '',
      ownerId: userId,
      membersIds: IList([userId]),
      isPublic: isPublic,
      title: title,
    ));
    return ref.id;
  }

  Future<void> addMember(String organizationId, String cartId, {required String userId}) async {
    await _ref(organizationId).doc(cartId).update({
      CartDtoFields.membersIds: FieldValue.arrayUnion([userId]),
    });
  }
}
