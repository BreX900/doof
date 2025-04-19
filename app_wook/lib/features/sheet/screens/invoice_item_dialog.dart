import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _dialogProvider = UsersProviders.all;

class InvoiceItemDialogResult {
  final UserDto user;
  final Decimal amount;

  InvoiceItemDialogResult({required this.user, required this.amount});
}

class InvoiceItemDialog extends ConsumerStatefulWidget {
  const InvoiceItemDialog({super.key});

  @override
  ConsumerState<InvoiceItemDialog> createState() => _InvoiceItemDialogState();
}

class _InvoiceItemDialogState extends ConsumerState<InvoiceItemDialog> {
  final _userControl = FormControl<UserDto>(
    validators: [Validators.required],
  );
  final _amountControl = FormControl<Decimal>();
  late final _form = FormArray([_userControl, _amountControl]);

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit(None _) async {
    Navigator.of(context).pop(InvoiceItemDialogResult(
      user: _userControl.value!,
      amount: _amountControl.value ?? Decimal.zero,
    ));
  }

  Widget _buildContent({required IList<UserDto> users}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReactiveDropdownField<UserDto>(
          formControl: _userControl,
          decoration: const InputDecoration(labelText: 'User'),
          items: users.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.displayName!),
            );
          }).toList(),
        ),
        ReactiveTypedTextField(
          formControl: _amountControl,
          variant: const TextFieldVariant.decimal(),
          valueAccessor: MekAccessors.decimalToString(
              NumberFormat.decimalPattern(Localizations.localeOf(context).toLanguageTag())),
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_dialogProvider);

    final submit = _form.handleSubmit(_submit);

    return AlertDialog(
      content: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_dialogProvider),
        data: (data) => _buildContent(users: data),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => submit(none),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
