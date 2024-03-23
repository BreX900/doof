import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/clients/screens/client_screen.dart';
import 'package:mek_gasol/modules/eti/features/clients/triggers/clients_trigger.dart';
import 'package:mek_gasol/modules/eti/features/projects/screens/projects_screen.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsState = ref.watch(ClientsTrigger.all);

    final clients = clientsState.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(error: error),
      data: (clients) {
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];

            return ListTile(
              onTap: () => context.hub.push(ProjectsScreen(
                clientId: client.id,
              )),
              title: Text(client.displayName),
              trailing: IconButton(
                onPressed: () => context.hub.push(ClientScreen(
                  client: client,
                )),
                icon: const Icon(Icons.edit),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(const ClientScreen(
              client: null,
            )),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: clients,
      ),
    );
  }
}
