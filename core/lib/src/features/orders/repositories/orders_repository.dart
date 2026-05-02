import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';

class OrdersRepository {
  static OrdersRepository get instance => OrdersRepository._();
  static const String collection = 'orders';

  FirebaseAuth get _auth => Instances.auth;

  FirebaseFirestore get _firestore => Instances.firestore;

  OrdersRepository._();

  CollectionReference<OrderDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(OrderDto.fromJson);

  Future<String> create(
    String organizationId, {
    required String payerId,
    required String cartId,
    required Iterable<String> membersIds,
    required String? place,
    required Fixed payedAmount,
  }) async {
    final now = DateTime.now();

    final ref = await _ref(organizationId).add(
      OrderDto(
        id: '',
        originCartId: cartId,
        createdAt: now,
        updatedAt: now,
        at: null,
        // TODO: Add orderAt
        organizationId: organizationId,
        shippable: false,
        payerId: payerId,
        membersIds: {payerId, ...membersIds}.toIList(),
        status: OrderStatus.accepting,
        place: place,
        payedAmount: payedAmount,
      ),
    );
    return ref.id;
  }

  /// Role: ADMIN
  Future<void> update(String organizationId, String orderId, OrderUpdateDto data) async {
    await _ref(organizationId).doc(orderId).update(data.toJson());
  }

  Future<void> delete(String organizationId, String orderId) async {
    await _ref(organizationId).doc(orderId).delete();
  }

  // Future<List<OrderDto>> fetchAll() async {
  //   final snapshot = await _ref().orderBy(OrderDto.fields.createdAt, descending: true).get();
  //   return snapshot.docs.map((e) => e.data()).toList();
  // }

  Future<OrderDto> fetch(String organizationId, String id) async {
    final snapshot = await _ref(organizationId).doc(id).get();
    return snapshot.data()!;
  }

  Future<IList<OrderDto>> fetchAll(
    String organizationId, {
    required String userId,
    List<OrderStatus> whereNotStatusIn = const [],
  }) async {
    var query = _ref(organizationId).where(OrderDtoFields.membersIds, arrayContains: userId);
    // if (organizationId != null) {
    //   query = query.where(OrderDto.fields.organizationId, isEqualTo: organizationId);
    // }
    if (whereNotStatusIn.isNotEmpty) {
      query = query
          .where(OrderDtoFields.status, whereNotIn: whereNotStatusIn.map((e) => e.name))
          .orderBy(OrderDtoFields.status);
    }
    final snapshot = await query.orderBy(OrderDtoFields.createdAt, descending: true).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }

  Future<IList<OrderDto>> fetchPage(String organizationId, Cursor cursor) async {
    final snapshot = await _ref(
      organizationId,
    ).orderBy(OrderDtoFields.updatedAt).apply(cursor).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }
}
