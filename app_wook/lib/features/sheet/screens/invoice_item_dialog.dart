import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _dialogProvider = UsersProviders.all;

class InvoiceItemDialogResult {
  final String userId;
  final Decimal amount;
  // final Decimal? payedAmount;

  const InvoiceItemDialogResult({
    required this.userId,
    required this.amount,
    // required this.payedAmount,
  });
}

class InvoiceItemDialog extends ConsumerStatefulWidget {
  final String? userId;
  final Decimal? amount;
  // final Decimal? vaultPayedAmount;

  const InvoiceItemDialog({
    super.key,
    this.userId,
    this.amount,
    // this.vaultPayedAmount,
  });

  @override
  ConsumerState<InvoiceItemDialog> createState() => _InvoiceItemDialogState();
}

class _InvoiceItemDialogState extends ConsumerState<InvoiceItemDialog> {
  late final _userControl = FormControl<String>(
    disabled: widget.userId != null,
    validators: [Validators.required],
    value: widget.userId,
  );
  late final _amountControl = FormControl<Decimal>(
    value: widget.amount,
  );
  // late final _payedAmountControl = FormControl<Decimal>(
  //   value: widget.vaultPayedAmount,
  // );
  late final _form = FormArray([_userControl, _amountControl]);

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit(None _) async {
    Navigator.of(context).pop(InvoiceItemDialogResult(
      userId: _userControl.value!,
      amount: _amountControl.value ?? Decimal.zero,
      // payedAmount: _payedAmountControl.value,
    ));
  }

  Widget _buildContent({required IList<UserDto> users}) {
    final formats = AppFormats.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReactiveDropdownField<String>(
          formControl: _userControl,
          decoration: const InputDecoration(labelText: 'User'),
          items: users.map((e) {
            return DropdownMenuItem(
              value: e.id,
              child: Text(e.displayName!),
            );
          }).toList(),
        ),
        ReactiveTypedTextField(
          formControl: _amountControl,
          variant: const TextFieldVariant.decimal(),
          valueAccessor: MekAccessors.decimalToString(formats.decimal),
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        // ReactiveTypedTextField(
        //   formControl: _payedAmountControl,
        //   variant: const TextFieldVariant.decimal(),
        //   valueAccessor: MekAccessors.decimalToString(formats.decimal),
        //   decoration: const InputDecoration(labelText: 'Vault payed amount'),
        // ),
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
