import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/organizations/repositories/organizations_repository.dart';
import 'package:core/src/features/tickets/dto/ticket_dto.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';

class TicketsRepository {
  static TicketsRepository get instance => TicketsRepository._();
  static const String collection = 'tickets';

  FirebaseFirestore get _firestore => Instances.firestore;

  TicketsRepository._();

  CollectionReference<TicketDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(TicketDto.fromJson);

  Future<void> create(String organizationId, TicketDto ticket) async {
    await _ref(organizationId).doc(ticket.id.nullIfEmpty).set(ticket);
  }

  // Future<void> delete(String organizationId, TicketDto ingredient) async {
  //   await _ref(organizationId).doc(ingredient.id).delete();
  // }

  Future<TicketDto> fetch(String organizationId, String id) async {
    final snapshot = await _ref(organizationId).doc(id).get();
    return snapshot.data()!;
  }

  Future<void> update(
    String organizationId,
    String id, {
    required TicketStatus status,
  }) async {
    final ticket = await fetch(organizationId, id);
    final updates = ticket.change((b) => b
      ..updatedAt = DateTime.now()
      ..status = status);
    await _ref(organizationId).doc(id).set(updates);
  }

  // Future<IList<TicketDto>> fetchAll(String organizationId) async {
  //   final snapshot = await _ref(organizationId)
  //       // .where(TicketDto.fields.productIds, arrayContains: productId)
  //       .orderBy(TicketDto.fields.title)
  //       .get();
  //   return snapshot.docs.map((e) => e.data()).toIList();
  // }

  Future<Stream<IList<TicketDto>>> watchPage(String organizationId, Cursor cursor) async {
    final onSnapshot = _ref(organizationId)
        .orderBy(TicketDtoFields.createAt, descending: true)
        .apply(cursor)
        .snapshots();
    return onSnapshot.map((snapshot) => snapshot.docs.map((e) => e.data()).toIList());
  }
}
