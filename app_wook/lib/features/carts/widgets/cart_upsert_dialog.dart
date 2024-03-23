import 'dart:async';

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
  final _titleFb = FieldBloc(initialValue: '');

  @override
  void dispose() {
    unawaited(_titleFb.close());
    super.dispose();
  }

  late final _create = ref.mutation((ref, _) async {
    await CartsProviders.create(
      ref,
      Env.organizationId,
      title: _titleFb.state.value,
    );
  }, onSuccess: (_, __) {
    widget.pop(context);
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watchIdle(mutations: [_create]);

    return AlertDialog(
      title: const Text('Create Cart'),
      content: FieldText(
        fieldBloc: _titleFb,
        converter: FieldConvert.text,
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
          onPressed: isIdle ? ref.handleSubmit(_titleFb, () => _create(null)) : null,
          child: const Text('Crea'),
        ),
      ],
    );
  }
}
