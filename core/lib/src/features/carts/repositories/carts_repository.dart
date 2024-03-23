import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firebase_auth_extensions.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/carts/dto/cart_dto.dart';
import 'package:core/src/features/organizations/repositories/organizations_repository.dart';
import 'package:core/src/shared/data/failure.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mek/mek.dart';
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
    return _ref(organizationId).doc(cartId).snapshots().map((snapshot) {
      final cart = snapshot.data();
      if (cart == null) throw TargetNotFoundFailure('$collection/$cartId');
      return cart;
    });
  }

  Future<CartDto?> fetchPersonal(String organizationId, {required String userId}) async {
    final snapshot = await _ref(organizationId)
        .where(CartDto.fields.membersIds, arrayContains: userId)
        .where(CartDto.fields.isPublic, isEqualTo: false)
        .get();
    return snapshot.docs.oneOrNull?.data();
  }

  Stream<IList<CartDto>> watchAll(String organizationId, {required String userId}) {
    return _ref(organizationId)
        .where(CartDto.fields.membersIds, arrayContains: userId)
        .orderBy(CartDto.fields.title)
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
      CartDto.fields.membersIds: FieldValue.arrayUnion([userId]),
    });
  }
}
