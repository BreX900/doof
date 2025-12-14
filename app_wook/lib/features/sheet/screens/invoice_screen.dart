import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/invoices_providers.dart';
import 'package:mek_gasol/features/sheet/invoices_utils.dart';
import 'package:mek_gasol/features/sheet/screens/invoice_item_dialog.dart';
import 'package:mek_gasol/shared/widgets/field_padding.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Left: Create
/// Right: Update
typedef _Args = Either<String?, String>;

sealed class _Data with EquatableAndDescribable {
  final IList<UserDto> users;
  final IList<InvoiceDto> invoices;

  _Data({required this.users, required this.invoices});

  @override
  Map<String, Object?> get props => {'users': users, 'invoices': invoices};
}

class _CreateData extends _Data {
  final OrderModel? order;
  final IList<OrderItemModel>? orderItems;

  _CreateData({
    required super.users,
    required super.invoices,
    required this.order,
    required this.orderItems,
  });

  @override
  Map<String, Object?> get props => super.props
    ..['order'] = order
    ..['orderItems'] = orderItems;
}

class _UpdateData extends _Data {
  final InvoiceDto invoice;

  _UpdateData({required super.users, required super.invoices, required this.invoice});

  @override
  Map<String, Object?> get props => super.props..['invoice'] = invoice;
}

final _screenProvider = FutureProvider.autoDispose.family((ref, _Args args) async {
  final invoices = await ref.read(InvoicesProviders.all.future);
  final users = await ref.watch(UsersProviders.all.future);

  return await args.when(
    (orderId) async {
      final order = orderId != null
          ? await ref.watch(OrdersProviders.single((Env.organizationId, orderId)).future)
          : null;

      return _CreateData(
        users: users,
        invoices: invoices,
        order: order,
        orderItems: orderId != null
            ? await ref.watch(OrderItemsProviders.all((Env.organizationId, orderId)).future)
            : null,
      );
    },
    (invoiceId) async {
      final invoice = await ref.watch(InvoicesProviders.single(invoiceId).future);

      return _UpdateData(users: users, invoices: invoices, invoice: invoice);
    },
  );
});

class InvoiceScreen extends SourceConsumerStatefulWidget {
  final _Args _args;

  const InvoiceScreen.create({super.key}) : _args = const Either.left(null);

  InvoiceScreen.update({super.key, required String invoiceId}) : _args = Either.right(invoiceId);

  InvoiceScreen.createFromOrder({super.key, required String orderId})
    : _args = Either.left(orderId);

  @override
  SourceConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends SourceConsumerState<InvoiceScreen> {
  FutureProvider<_Data> get _provider => _screenProvider(widget._args);

  final _payerFb = FormControlTypedOptional<UserDto>(validators: [ValidatorsTyped.required()]);
  final _payedAmountControl = FormControlTypedOptional<Fixed>();
  final _itemsFb = FormList<_ItemFieldBloc, void>(
    [],
    validators: [ValidatorsTyped.iterable(minLength: 1)],
  );

  final _isVaultUsedControl = FormControlTyped<bool>(initialValue: false);
  final _vaultOutcomesControl = FormMap<FormControlTypedOptional<Fixed>, Fixed>({});

  late final _form = FormArray<void>([
    _payerFb,
    _payedAmountControl,
    _itemsFb,
    _isVaultUsedControl,
    _vaultOutcomesControl,
  ]);

  @override
  void initState() {
    super.initState();

    unawaited(_init());
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final data = await ref.futureOfData(_provider);
    final _Data(:invoices) = data;
    final vault = InvoicesUtils.calculateVault(invoices);

    _itemsFb.clear(emitEvent: false, updateParent: false);

    _vaultOutcomesControl.addAll(
      vault.keys.map((userId) {
        return MapEntry(userId, FormControlTypedOptional<Fixed>());
      }).toMap(),
    );

    switch (data) {
      case _CreateData(:final orderItems):
        final amounts = orderItems?.fold(<UserDto, Fixed>{}, (amounts, item) {
          return {
            ...amounts,
            for (final buyer in item.buyers)
              buyer: (amounts[buyer] ?? Fixed.zero) + item.individualCost,
          };
        });
        _itemsFb.addAll(
          (amounts ?? {}).entries.mapTo((user, amount) {
            return _ItemFieldBloc(
              userId: user.id,
              value: InvoiceItemDto(
                amount: amount,
                isPayed: false,
                jobs: const IList.empty(),
                // vaultUsedAmount: null,
              ),
            );
          }).toList(),
        );

      case _UpdateData(:final users, :final invoice):
        final isCurrentUserThePayer = Instances.auth.currentUser?.uid == invoice.payerId;

        _payerFb.updateValue(users.firstWhereIdOrNull(invoice.payerId));
        _payedAmountControl.updateValue(invoice.payedAmount);
        _isVaultUsedControl.updateValue(invoice.vaultOutcomes != null);
        _vaultOutcomesControl.updateValue(invoice.vaultOutcomes?.unlockView);

        _itemsFb.addAll(
          invoice.items.mapTo((userId, value) {
            return _ItemFieldBloc(disabled: !isCurrentUserThePayer, userId: userId, value: value);
          }).toList(),
        );
    }
  }

  late final _createInvoice = ref.mutation(
    (ref, OrderModel? order) async {
      final isVaultUsed = _isVaultUsedControl.value;
      await InvoicesProviders.create(
        ref,
        order: order,
        payerId: _payerFb.value!.id,
        payedAmount: _payedAmountControl.value,
        vaultOutcomes: isVaultUsed ? _vaultOutcomesControl.value.lockUnsafe.nonNullValues : null,
        items: _itemsFb.controls.map((e) => MapEntry(e.userId, e.toValue())).toIMap(),
      );
    },
    onError: (_, error) {
      CoreUtils.showErrorSnackBar(context, error);
    },
    onSuccess: (_, __) {
      context.pop();
    },
  );

  late final _updateInvoice = ref.mutation(
    (ref, InvoiceDto invoice) async {
      final isVaultUsed = _isVaultUsedControl.value;
      await InvoicesProviders.update(
        ref,
        invoice: invoice,
        payerId: _payerFb.value!.id,
        payedAmount: _payedAmountControl.value,
        vaultOutcomes: isVaultUsed ? _vaultOutcomesControl.value.lockUnsafe.nonNullValues : null,
        items: _itemsFb.controls.map((e) => MapEntry(e.userId, e.toValue())).toIMap(),
      );
    },
    onError: (_, error) {
      CoreUtils.showErrorSnackBar(context, error);
    },
    onSuccess: (_, __) {
      context.pop();
    },
  );

  Future<void> _showItemUpsertDialog([_ItemFieldBloc? formControl]) async {
    final result = await showDialog<InvoiceItemDialogResult>(
      context: context,
      builder: (context) =>
          InvoiceItemDialog(userId: formControl?.userId, amount: formControl?.amountControl.value),
    );
    if (result == null) return;

    if (formControl != null) {
      formControl.amountControl.updateValue(result.amount);
    } else {
      _itemsFb.add(
        _ItemFieldBloc(
          userId: result.userId,
          value: InvoiceItemDto(amount: result.amount, isPayed: false, jobs: const IList.empty()),
        ),
      );
    }
  }

  Widget _buildBody({required IList<InvoiceDto> invoices, required IList<UserDto> users}) {
    final formats = AppFormats.of(context);
    final ThemeData(:colorScheme) = Theme.of(context);

    final itemsFb = ref.watchSource(_itemsFb.source.controlsTyped);
    final itemsError = ref.watchSource(_itemsFb.source.error);

    final children = <Widget>[
      FieldPadding(
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ReactiveDropdownField<UserDto>(
                formControl: _payerFb,
                decoration: const InputDecoration(labelText: 'Payer'),
                items: users.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e.displayName!));
                }).toList(),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: ReactiveTypedTextField(
                formControl: _payedAmountControl,
                variant: const TextFieldVariant.decimal(),
                valueAccessor: MekAccessors.decimalToString(formats.decimal),
                decoration: const InputDecoration(prefixText: '€ ', labelText: 'Payed amount'),
              ),
            ),
          ],
        ),
      ),
      const Divider(height: 24.0),
      ...itemsFb
          .map((formControl) => (formControl, users.firstWhere((e) => e.id == formControl.userId)))
          .sortedBy((e) => e.$2.displayName!)
          .expandIndexed<Widget>((index, __) sync* {
            final (formControl, user) = __;

            if (index > 0) yield const Divider(indent: 16.0, endIndent: 16.0);

            yield Dismissible(
              key: ValueKey(formControl),
              onDismissed: (_) => _itemsFb.remove(formControl),
              child: Column(
                children: [
                  ReactiveSwitchListTile(
                    formControl: formControl.isPayedFb,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(user.displayName!),
                    subtitle: Text(
                      'Did he pay? ${formats.formatPrice(formControl.toValue().amount)}',
                    ),
                    secondary: IconButton(
                      onPressed: () async => _showItemUpsertDialog(formControl),
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  FieldPadding(
                    ReactiveSegmentedButton<Job>.multi(
                      formControl: formControl.jobsFb,
                      emptySelectionAllowed: true,
                      showSelectedIcon: false,
                      segments: Job.values.reversed.map((e) {
                        return ButtonSegment(value: e, label: Text(e.label));
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
      if (itemsError != null)
        Text(
          ReactiveFormConfig.of(context).buildErrorText(itemsError),
          style: TextStyle(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      const Divider(),
      BottomButtonBar(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: _showItemUpsertDialog,
              icon: const Icon(Icons.people),
              label: const Text('Add User'),
            ),
          ),
        ],
      ),
      const FloatingActionButtonInjector(),
    ];

    final vault = InvoicesUtils.calculateVault(invoices);
    final vaultOutcomesControls = ref.watchSource(_vaultOutcomesControl.source.controlsTyped);

    final isVaultUsed = ref.watchSource(_isVaultUsedControl.source.value) ?? false;
    final usedAmount = ref.watchSource(
      _vaultOutcomesControl.source.value.select((entries) {
        return entries?.values.nonNulls.cast<Fixed>().sum ?? Fixed.zero;
      }),
    );
    final payedAmount = ref.watchSource(_payedAmountControl.source.value) ?? Fixed.zero;
    final missingAmount = Fixed.max(payedAmount - usedAmount, Fixed.zero);
    final isVaultOutcomesValid = missingAmount == Fixed.zero;

    final vaultView = SingleChildScrollView(
      child: Column(
        children: [
          ReactiveSwitchListTile(
            formControl: _isVaultUsedControl,
            secondary: Icon(
              Icons.token,
              size: 48.0,
              color: !isVaultUsed ? null : (isVaultOutcomesValid ? Colors.green : Colors.red),
            ),
            title: const Text('Open the vault to pay?'),
            subtitle: Text(
              'The vault has ${formats.formatCaps(vault.values.sum)}.\n'
              'Payed ${formats.formatPrice(payedAmount)}\n'
              'Withdrawal ${formats.formatCaps(usedAmount)}',
            ),
          ),
          if (isVaultUsed)
            ...vaultOutcomesControls.mapTo((userId, control) {
              final hasValue = !ref.watchSource(control.source.value.isNull);
              final user = users.firstWhereOrNull((e) => e.id == userId);
              final vaultAmount = vault[userId] ?? Fixed.zero;

              return FieldPadding(
                ReactiveTypedTextField(
                  formControl: control,
                  valueAccessor: MekAccessors.decimalToString(formats.decimal),
                  variant: const TextFieldVariant.decimal(),
                  decoration: InputDecoration(
                    labelText: user?.displayName,
                    prefixIcon: const Icon(Icons.catching_pokemon),
                    suffixIcon: !hasValue
                        ? TextButton(
                            onPressed: () =>
                                control.updateValue(Fixed.min(vaultAmount, missingAmount)),
                            child: const Text('Auto-Fill'),
                          )
                        : const ReactiveClearButton(),
                    helperText: 'Vault availability ${formats.formatCaps(vaultAmount)}',
                  ),
                ),
              );
            }),
          const FloatingActionButtonInjector(),
        ],
      ),
    );

    return TabBarView(
      children: [
        HarmonicSingleChildScrollView(child: Column(children: children)),
        vaultView,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final data = state.value;
    final isIdle = !ref.watchIsMutating([_createInvoice]);
    final createInvoice = _form.handleSubmitWith(_createInvoice);
    final updateInvoice = _form.handleSubmitWith(_updateInvoice);

    final formats = AppFormats.of(context);

    final invoiceLabel = switch (data) {
      null => '...',
      _CreateData() => '',
      _UpdateData(:final invoice) =>
        ': ${formats.formatDate(invoice.createdAt)} - ${formats.formatPrice(invoice.amount)}',
    };

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Invoice$invoiceLabel'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt_long)),
              Tab(icon: Icon(Icons.token)),
            ],
          ),
        ),
        floatingActionButton: FixedFloatingActionButton.extended(
          onPressed: switch (isIdle ? data : null) {
            null => null,
            _CreateData(:final order) => () => createInvoice(order),
            _UpdateData(:final invoice) => () => updateInvoice(invoice),
          },
          icon: widget._args.when((_) => const Icon(Icons.add), (_) => const Icon(Icons.edit)),
          label: Text(widget._args.when((_) => 'Create', (_) => 'Update')),
        ),
        body: state.buildView(
          onRefresh: () => ref.invalidateWithAncestors(_provider),
          data: (data) => _buildBody(invoices: data.invoices, users: data.users),
        ),
      ),
    );
  }
}

class _ItemFieldBloc extends FormArray<void> {
  final String userId;

  final amountControl = FormControlTyped(initialValue: Fixed.zero);
  final isPayedFb = FormControlTyped(initialValue: false);
  final jobsFb = FormControlTyped<ISet<Job>>(initialValue: const ISet.empty());

  _ItemFieldBloc({required this.userId, required InvoiceItemDto value, bool disabled = false})
    : super([]) {
    updateValueByDto(value);
    addAll([isPayedFb, jobsFb]);
    if (disabled) markAsDisabled(emitEvent: false);
  }

  void updateValueByDto(InvoiceItemDto data) {
    amountControl.updateValue(data.amount);
    isPayedFb.updateValue(data.isPayed);
    jobsFb.updateValue(data.jobs.toISet());
  }

  InvoiceItemDto toValue() {
    return InvoiceItemDto(
      amount: amountControl.value,
      isPayed: isPayedFb.value,
      jobs: jobsFb.value.toIList(),
    );
  }
}
