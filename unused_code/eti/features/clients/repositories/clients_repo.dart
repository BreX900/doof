import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:riverpod/riverpod.dart';

class ClientsRepo extends FirestoreRepository<ClientDvo> {
  static final instance = Provider((ref) {
    return ClientsRepo(ref);
  });

  ClientsRepo(Ref ref)
      : super(
          ref: ref,
          collectionName: 'clients',
          fromFirestore: ClientDvo.fromJson,
        );

  Stream<List<ClientDvo>> watchAll() {
    final matchesQuery = box.watchCollection.orderBy(ClientDvo.displayNameKey, descending: false);

    return matchesQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
