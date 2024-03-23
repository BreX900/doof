import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/projects/screens/project_screen.dart';
import 'package:mek_gasol/modules/eti/features/projects/triggers/projects_trigger.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

class ProjectsScreen extends ConsumerWidget {
  final String clientId;

  const ProjectsScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsState = ref.watch(ProjectsTrigger.all(clientId));

    final clients = clientsState.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(error: error),
      data: (clients) {
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];

            return ListTile(
              title: Text(client.name),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(ProjectScreen(
              clientId: clientId,
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
