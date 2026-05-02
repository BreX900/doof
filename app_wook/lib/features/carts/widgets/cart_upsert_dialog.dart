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
  late final _mutation = MutationController(ref);

  final _titleFb = FormControlTyped(initialValue: '');

  @override
  void dispose() {
    _titleFb.dispose();
    _mutation.dispose();
    super.dispose();
  }

  void _create(_) => _mutation(
    (ref) async => await CartsProviders.create(ref, Env.organizationId, title: _titleFb.value),
    onError: (error, _) => CoreUtils.showErrorSnackBar(context, error),
    onSuccess: (_) => widget.pop(context),
  );

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watch(_mutation.provider.isIdle);
    final create = _titleFb.handleSubmitWith(_create);

    return AlertDialog(
      title: const Text('Create Cart'),
      content: ReactiveTypedTextField(
        formControl: _titleFb,
        decoration: const InputDecoration(labelText: 'Title'),
      ),
      actions: [
        TextButton(onPressed: () => widget.pop(context), child: const Text('Anulla')),
        ElevatedButton(onPressed: isIdle ? () => create(null) : null, child: const Text('Crea')),
      ],
    );
  }
}
