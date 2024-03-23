import 'package:mek_gasol/modules/eti/features/clients/repositories/clients_repo.dart';
import 'package:riverpod/riverpod.dart';

abstract class ClientsTrigger {
  static final all = StreamProvider((ref) {
    final clientsRepo = ref.watch(ClientsRepo.instance);

    return clientsRepo.watchAll();
  });
}
