import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/invoices_providers.dart';
import 'package:mek_gasol/features/sheet/screens/invoice_item_dialog.dart';
import 'package:mek_gasol/shared/widgets/field_padding.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef _Args = Either<String?, String>;

final _screenProvider = FutureProvider.autoDispose.family((ref, _Args args) async {
  return await args.whenAsync((orderId) async {
    final order = orderId != null
        ? await ref.watch(OrdersProviders.single((Env.organizationId, orderId)).future)
        : null;
    final users = await ref.watch(UsersProviders.all.future);

    return (
      order: order,
      items: orderId != null
          ? await ref.watch(OrderItemsProviders.all((Env.organizationId, orderId)).future)
          : null,
      users: order?.members ?? users,
    );
  }, (invoiceId) async {
    final invoice = await ref.watch(InvoicesProviders.single(invoiceId).future);
    final allUsers = await ref.watch(UsersProviders.all.future);

    final users = invoice.items.keys.map(allUsers.firstWhereId).toIList();

    return (invoice: invoice, users: users);
  });
});

class InvoiceScreen extends ConsumerStatefulWidget {
  final _Args _args;

  const InvoiceScreen({super.key}) : _args = const Either.left(null);

  InvoiceScreen.update({
    super.key,
    required String invoiceId,
  }) : _args = Either.right(invoiceId);

  InvoiceScreen.fromOrder({
    super.key,
    required String orderId,
  }) : _args = Either.left(orderId);

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  AutoDisposeFutureProvider<
      Either<({IList<OrderItemModel>? items, OrderModel? order, IList<UserDto> users}),
          ({InvoiceDto invoice, IList<UserDto> users})>> get _provider =>
      _screenProvider(widget._args);

  final _payerFb = FormControlTypedOptional<UserDto>(
    validators: [ValidatorsTyped.required()],
  );
  final _itemsFb = FormList<_ItemFieldBloc, void>(
    [],
    validators: [ValidatorsTyped.iterable(minLength: 1)],
  );

  late final _form = FormArray<void>([_payerFb, _itemsFb]);

  @override
  void initState() {
    super.initState();

    ref.listenManual(_provider, (previous, next) {
      next.whenOrNull(data: (data) {
        _itemsFb.clear(emitEvent: false, updateParent: false);
        data.when((items) {
          final orderItems = items.items;

          final amounts = orderItems?.fold(<UserDto, Decimal>{}, (amounts, item) {
            return {
              ...amounts,
              for (final buyer in item.buyers)
                buyer: (amounts[buyer] ?? Decimal.zero) + item.individualCost,
            };
          });
          _itemsFb.addAll((amounts ?? {}).entries.mapTo((user, amount) {
            return _ItemFieldBloc(
              user: user,
              value: InvoiceItemDto(
                amount: amount,
                isPayed: false,
                jobs: [],
              ),
            );
          }).toList());
        }, (items) {
          final invoice = items.invoice;
          final users = items.users;

          _payerFb.updateValue(users.firstWhereIdOrNull(invoice.payerId));

          _itemsFb.addAll(invoice.items.mapTo((key, value) {
            return _ItemFieldBloc(user: users.firstWhereId(key), value: value);
          }).toList());
        });
      });
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  late final _createInvoice = ref.mutation((ref, OrderModel? order) async {
    await InvoicesProviders.create(
      ref,
      order: order,
      payerId: _payerFb.value!.id,
      items: _itemsFb.controls.map((e) => MapEntry(e.user.id, e.toValue())).toMap(),
    );
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onSuccess: (_, __) {
    context.pop();
  });

  late final _updateInvoice = ref.mutation((ref, InvoiceDto invoice) async {
    await InvoicesProviders.update(
      ref,
      invoice: invoice,
      payerId: _payerFb.value!.id,
      items: _itemsFb.controls.map((e) => MapEntry(e.user.id, e.toValue())).toMap(),
    );
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onSuccess: (_, __) {
    context.pop();
  });

  Future<void> _addUser() async {
    final result = await showDialog<InvoiceItemDialogResult>(
      context: context,
      builder: (context) => const InvoiceItemDialog(),
    );
    if (result == null) return;
    _itemsFb.add(_ItemFieldBloc(
      user: result.user,
      value: InvoiceItemDto(
        amount: result.amount,
        isPayed: false,
        jobs: [],
      ),
    ));
  }

  Widget _buildBody({required IList<UserDto> users}) {
    final formats = AppFormats.of(context);
    final ThemeData(:colorScheme) = Theme.of(context);

    final itemsFb = ref.watch(_itemsFb.provider.controls);
    final itemsError = ref.watch(_itemsFb.provider.error);

    final children = <Widget>[
      FieldPadding(ReactiveDropdownField<UserDto>(
        formControl: _payerFb,
        decoration: const InputDecoration(labelText: 'Payer'),
        items: users.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.displayName!),
          );
        }).toList(),
      )),
      const Divider(height: 24.0),
      ...itemsFb
          .sortedBy((e) => e.user.displayName!)
          .expandIndexed<Widget>((index, itemFieldBloc) sync* {
        if (index > 0) yield const Divider(indent: 16.0, endIndent: 16.0);
        yield Dismissible(
          key: ValueKey(itemFieldBloc),
          onDismissed: (_) => _itemsFb.remove(itemFieldBloc),
          child: Column(
            children: [
              ReactiveSwitchListTile(
                formControl: itemFieldBloc.isPayedFb,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(itemFieldBloc.user.displayName!),
                subtitle:
                    Text('Did he pay? ${formats.formatPrice(itemFieldBloc.toValue().amount)}'),
              ),
              FieldPadding(ReactiveSegmentedButton<Job>.multi(
                formControl: itemFieldBloc.jobsFb,
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: Job.values.map((e) {
                  return ButtonSegment(value: e, label: Text(e.name));
                }).toList(),
              )),
            ],
          ),
        );
      }),
      if (itemsError != null)
        Text(ReactiveFormConfig.of(context).buildErrorText(itemsError),
            style: TextStyle(color: colorScheme.error), textAlign: TextAlign.center),
      TextButton.icon(
        onPressed: _addUser,
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    ];

    return HarmonicSingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final data = state.valueOrNull;
    final isIdle = !ref.watchIsMutating([_createInvoice]);
    final createInvoice = _form.handleSubmit(_createInvoice.run);
    final updateInvoice = _form.handleSubmit(_updateInvoice.run);

    final formats = AppFormats.of(context);

    final invoiceId = data?.when((_) {
          return '';
        }, (items) {
          return ': ${formats.formatDate(items.invoice.createdAt)}';
        }) ??
        '...';

    return HarmonicScaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Invoice$invoiceId'),
      ),
      floatingActionButton: FixedFloatingActionButton.extended(
        onPressed: isIdle
            ? data?.when((items) {
                return () => createInvoice(items.order);
              }, (items) {
                return () => updateInvoice(items.invoice);
              })
            : null,
        icon: widget._args.when((_) => const Icon(Icons.add), (_) => const Icon(Icons.edit)),
        label: Text(widget._args.when((_) => 'Create', (_) => 'Update')),
      ),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: (data) => _buildBody(
          users: data.when((items) => items.users, (items) => items.users),
        ),
      ),
    );
  }
}

class _ItemFieldBloc extends FormArray<void> {
  final UserDto user;
  late InvoiceItemDto _value;

  final isPayedFb = FormControlTyped(initialValue: false);
  final jobsFb = FormControlTyped<ISet<Job>>(initialValue: const ISet.empty());

  _ItemFieldBloc({required this.user, required InvoiceItemDto value}) : super([]) {
    updateValueByDto(value);
    addAll([isPayedFb, jobsFb]);
  }

  void updateValueByDto(InvoiceItemDto data) {
    _value = data;

    isPayedFb.updateValue(data.isPayed);
    jobsFb.updateValue(data.jobs.toISet());
  }

  InvoiceItemDto toValue() {
    return InvoiceItemDto(
      amount: _value.amount,
      isPayed: isPayedFb.value,
      jobs: jobsFb.value.toList(),
    );
  }
}
