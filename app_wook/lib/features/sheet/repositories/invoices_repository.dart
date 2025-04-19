import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mekart/mekart.dart';

class InvoicesRepository {
  static InvoicesRepository get instance => InvoicesRepository._();
  static const String collection = 'invoices';

  FirebaseFirestore get _firestore => Instances.firestore;

  InvoicesRepository._();

  CollectionReference<InvoiceDto> _ref() =>
      _firestore.collection(collection).withJsonConverter(InvoiceDto.fromJson);

  Future<void> save(InvoiceDto invoice) async {
    await _ref().doc(invoice.id.nullIfEmpty).set(invoice);
  }

  Future<void> delete(InvoiceDto invoice) async {
    await _ref().doc(invoice.id).delete();
  }

  Future<InvoiceDto?> fetch(String invoiceId) async {
    final snapshot = await _ref().doc(invoiceId).get();
    return snapshot.data();
  }

  Stream<IList<InvoiceDto>> watchAll() {
    return _ref()
        .orderBy(InvoiceDtoFields.createdAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toIList());
  }
}
