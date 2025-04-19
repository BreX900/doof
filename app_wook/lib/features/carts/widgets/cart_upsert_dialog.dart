import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';

class CartUpsertDialog extends ConsumerStatefulWidget with TypedWidgetMixin<void> {
  const CartUpsertDialog({super.key});

  @override
  ConsumerState<CartUpsertDialog> createState() => _CartCreateDialogState();
}

class _CartCreateDialogState extends ConsumerState<CartUpsertDialog> {
  final _titleFb = FormControlTyped(initialValue: '');

  @override
  void dispose() {
    _titleFb.dispose();
    super.dispose();
  }

  late final _create = ref.mutation((ref, _) async {
    await CartsProviders.create(
      ref,
      Env.organizationId,
      title: _titleFb.value,
    );
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onSuccess: (_, __) {
    widget.pop(context);
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = !ref.watchIsMutating([_create]);
    final create = _titleFb.handleSubmit(_create.run);

    return AlertDialog(
      title: const Text('Create Cart'),
      content: ReactiveTypedTextField(
        formControl: _titleFb,
        decoration: const InputDecoration(
          labelText: 'Title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => widget.pop(context),
          child: const Text('Anulla'),
        ),
        ElevatedButton(
          onPressed: isIdle ? () => create(null) : null,
          child: const Text('Crea'),
        ),
      ],
    );
  }
}
