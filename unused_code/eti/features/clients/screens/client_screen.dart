import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/clients/blocs/clients_bloc.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

final _form = BlocProvider.family.autoDispose((ref, ClientDvo? client) {
  return TextFieldBloc(
    initialValue: client?.displayName ?? '',
    validators: [
      FieldBlocValidators.required,
    ],
  );
});

final _save = MutationProvider.family.autoDispose((ref, ClientDvo? client) {
  return MutationBloc((param) async {
    final clients = ref.read(ClientsBloc.instance);
    final formBloc = ref.read(_form(client).bloc);

    await clients.save(ClientDvo(
      id: client?.id ?? '',
      displayName: formBloc.value,
    ));
  });
});

final _delete = MutationProvider.family.autoDispose((ref, ClientDvo client) {
  return MutationBloc((param) async {
    final clients = ref.read(ClientsBloc.instance);

    await clients.delete(client.id);
  });
});

class ClientScreen extends ConsumerWidget {
  final ClientDvo? client;

  const ClientScreen({
    Key? key,
    required this.client,
  }) : super(key: key);

  void save(WidgetRef ref) {
    ref.read(_save(client).bloc).maybeMutate(null);
  }

  void delete(WidgetRef ref, ClientDvo client) {
    ref.read(_delete(client).bloc).maybeMutate(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = this.client;
    final formBloc = ref.watch(_form(client).bloc);

    ref.listen<MutationState>(_save(client), (previous, next) {
      next.mapOrNull(success: (_) {
        context.hub.pop();
      });
    });

    if (client != null) {
      ref.listen<MutationState>(_delete(client), (previous, next) {
        next.mapOrNull(success: (_) {
          context.hub.pop();
        });
      });
    }

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(_save(client).select((state) => !state.isMutating));
        final canSubmit = ref.watch(_form(client).select((state) {
          return !state.hasUpdatedValue && !state.isValidating;
        }));

        return AppFloatingActionButton(
          onPressed: canSave && canSubmit ? () => save(ref) : null,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
          // child: const Icon(Icons.check),
        );
      },
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: client != null ? Text(client.displayName) : const Text('Add client'),
        actions: [
          if (client != null)
            IconButton(
              onPressed: () => delete(ref, client),
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldBlocBuilder(
              textFieldBloc: formBloc,
            ),
          ],
        ),
      ),
      floatingActionButton: buttonBar,
    );
  }
}
