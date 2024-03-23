import 'dart:async';

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
import 'package:mek_gasol/shared/widgets/bottom_button_bar.dart';
import 'package:pure_extensions/pure_extensions.dart';

typedef _Args = Either<String, String>;

final _stateProvider = FutureProvider.autoDispose.family((ref, _Args args) async {
  return await args.whenAsync((orderId) async {
    final order = await ref.watch(OrdersProviders.single((Env.organizationId, orderId)).future);

    return (
      order: order,
      items: await ref.watch(OrderItemsProviders.all((Env.organizationId, orderId)).future),
      members: order.members,
    );
  }, (invoiceId) async {
    final invoice = await ref.watch(InvoicesProviders.single(invoiceId).future);
    final allUsers = await ref.watch(UsersProviders.all.future);

    final users = invoice.items.keys.map(allUsers.firstWhereId).toIList();

    return (invoice: invoice, users: users);
  });
});

class InvoiceScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final _Args _args;

  InvoiceScreen({
    super.key,
    required String invoiceId,
  }) : _args = Either.right(invoiceId);

  InvoiceScreen.fromOrder({
    super.key,
    required String orderId,
  }) : _args = Either.left(orderId);

  late final stateProvider = _stateProvider(_args);

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> with AsyncConsumerState {
  final _payerFb = FieldBloc<UserDto?>(
    initialValue: null,
    validator: const RequiredValidation<UserDto>(),
  );
  final _itemsFb = ListFieldsBloc<_ItemFieldBloc, void>();

  late final _form = ListFieldBloc<void>(fieldBlocs: [_payerFb, _itemsFb]);

  @override
  void initState() {
    super.initState();

    ref.listenManual(widget.stateProvider, (previous, next) {
      next.whenOrNull(data: (data) {
        data.when((items) {
          final orderItems = items.items;

          final amounts = orderItems.fold(<UserDto, Decimal>{}, (amounts, item) {
            return {
              ...amounts,
              for (final buyer in item.buyers)
                buyer: (amounts[buyer] ?? Decimal.zero) + item.individualCost,
            };
          });

          _itemsFb.updateFieldBlocs(amounts.entries.mapTo((user, amount) {
            return _ItemFieldBloc(
              user: user,
              value: InvoiceItemDto(
                amount: amount,
                isPayed: false,
                jobs: [],
              ),
            );
          }));
        }, (items) {
          final invoice = items.invoice;
          final users = items.users;

          _payerFb.updateValue(users.firstWhereIdOrNull(invoice.payerId));

          _itemsFb.updateFieldBlocs(invoice.items.generateIterable((key, value) {
            return _ItemFieldBloc(user: users.firstWhereId(key), value: value);
          }));
        });
      });
    });
  }

  @override
  void dispose() {
    unawaited(_form.close());
    super.dispose();
  }

  late final _createInvoice = ref.mutation((ref, OrderModel order) async {
    await InvoicesProviders.create(
      ref,
      order: order,
      payerId: _payerFb.state.value!.id,
      items: _itemsFb.state.fieldBlocs.map((e) => MapEntry(e.user.id, e.value)).toMap(),
    );
  }, onSuccess: (_, __) {
    context.pop();
  });

  late final _updateInvoice = ref.mutation((ref, InvoiceDto invoice) async {
    await InvoicesProviders.update(
      ref,
      invoice: invoice,
      payerId: _payerFb.state.value!.id,
      items: _itemsFb.state.fieldBlocs.map((e) => MapEntry(e.user.id, e.value)).toMap(),
    );
  }, onSuccess: (_, __) {
    context.pop();
  });

  Widget _buildBody({required IList<UserDto> users}) {
    final formats = AppFormats.of(context);

    final itemsFb = ref.watch(_itemsFb.select((state) => state.fieldBlocs));

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FieldDropdown(
          fieldBloc: _payerFb,
          decoration: const InputDecoration(labelText: 'Payer'),
          items: users.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.displayName!),
            );
          }).toList(),
        ),
      ),
      const Divider(height: 24.0),
      ...itemsFb.sortedBy((e) => e.user.displayName!).map<Widget>((itemFieldBloc) {
        return Column(
          children: [
            FieldSwitchListTile(
              fieldBloc: itemFieldBloc.isPayedFb,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: Text(itemFieldBloc.user.displayName!),
              subtitle: Text('Did he pay? ${formats.formatPrice(itemFieldBloc.value.amount)}'),
            ),
            FieldSegmentedButton(
              fieldBloc: itemFieldBloc.jobsFb,
              multiSelectionEnabled: true,
              emptySelectionAllowed: true,
              decoration: FieldBuilder.decorationFlat.copyWith(
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              ),
              segments: Job.values.map((e) {
                return ButtonSegment(value: e, label: Text(e.name));
              }).toList(),
            ),
          ],
        );
      }).joinElement(const Divider(indent: 16.0, endIndent: 16.0)),
    ];

    return ListView(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final data = state.valueOrNull;
    final isIdle = ref.watchIdle(mutations: [_createInvoice]);

    final formats = AppFormats.of(context);

    final invoiceId = data?.when((_) {
          return '';
        }, (items) {
          return ': ${formats.formatDate(items.invoice.createdAt)}';
        }) ??
        '...';

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice$invoiceId'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isIdle
                  ? data?.when(
                      (items) => ref.handleSubmit(_form, () => _createInvoice(items.order)),
                      (items) => ref.handleSubmit(_form, () => _updateInvoice(items.invoice)),
                    )
                  : null,
              icon: widget._args.when((_) => const Icon(Icons.add), (_) => const Icon(Icons.edit)),
              label: Text(widget._args.when((_) => 'Create', (_) => 'Update')),
            ),
          ),
        ],
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: (context, data) => _buildBody(
          users: data.when((items) => items.members, (items) => items.users),
        ),
      ),
    );
  }
}

class _ItemFieldBloc extends ListFieldBloc<void> {
  final UserDto user;
  late InvoiceItemDto _value;

  final isPayedFb = FieldBloc(initialValue: false);
  final jobsFb = FieldBloc<Set<Job>>(initialValue: {});

  _ItemFieldBloc({required this.user, required InvoiceItemDto value}) {
    updateValueByDto(value);

    addFieldBlocs([isPayedFb, jobsFb]);
  }

  void updateValueByDto(InvoiceItemDto data) {
    _value = data;

    isPayedFb.updateValue(data.isPayed);
    jobsFb.updateValue(data.jobs.toSet());
  }

  InvoiceItemDto get value {
    return InvoiceItemDto(
      amount: _value.amount,
      isPayed: isPayedFb.state.value,
      jobs: jobsFb.state.value.toList(),
    );
  }
}
