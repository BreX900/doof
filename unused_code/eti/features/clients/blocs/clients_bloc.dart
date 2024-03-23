import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/clients/repositories/clients_repo.dart';
import 'package:mek_gasol/modules/eti/features/clients/triggers/clients_trigger.dart';
import 'package:riverpod/riverpod.dart';

class ClientsBloc {
  static final instance = Provider((ref) {
    return ClientsBloc._(ref);
  });

  final Ref _ref;

  ClientsRepo get _clients => _ref.read(ClientsRepo.instance);

  ClientsBloc._(this._ref);

  Future<void> save(ClientDvo client) async {
    if (client.id.isEmpty) {
      await _clients.create(client);
    } else {
      await _clients.update(client);
    }
  }

  Future<void> delete(String clientId) async {
    await _clients.delete(clientId);
  }

  static final all = FutureProvider((ref) async {
    return await ref.watch(ClientsTrigger.all);
  });
}
