import 'dart:async';

import 'package:backoffice/shared/widgets/admin_body_layout.dart';
import 'package:backoffice/shared/widgets/pointed_list.dart';
import 'package:backoffice/shared/widgets/sliver_cards_layout.dart';
import 'package:backoffice/shared/widgets/sliver_fields_layout.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

final _stateProvider =
    FutureProvider.autoDispose.family((ref, (String organizationId, String orderId) args) async {
  final (organizationId, orderId) = args;
  return (
    order: await ref.watch(OrdersProviders.single((organizationId, orderId)).future),
    orderItems: await ref.watch(OrderItemsProviders.all((organizationId, orderId)).future),
  );
});

class AdminOrderScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final String organizationId;
  final String orderId;

  AdminOrderScreen({
    super.key,
    required this.organizationId,
    required this.orderId,
  });

  late final stateProvider = _stateProvider((organizationId, orderId));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<AdminOrderScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends ConsumerState<AdminOrderScreen> with AsyncConsumerState {
  final _statusFb = FieldBloc<OrderStatus?>(
    initialValue: null,
    validator: const RequiredValidation<OrderStatus>(),
  );

  late final _form = ListFieldBloc<void>(fieldBlocs: [_statusFb]);

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    unawaited(_form.close());
    super.dispose();
  }

  Future<void> _init() async {
    final items = await ref.read(widget.stateProvider.futureOfData);
    final order = items.order;

    _statusFb.updateValue(order.status);
  }

  late final _update = ref.mutation((ref, _) async {
    await OrdersProviders.update(
      ref,
      widget.organizationId,
      widget.orderId,
      status: _statusFb.state.value!,
    );
  }, onSuccess: (_, __) {
    context.pop();
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final items = state.valueOrNull;
    final isIdle = !ref.watchIsMutating([_update]);

    final formats = AppFormats.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order: ${items != null ? formats.formatDate(items.order.createdAt) : '...'}'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? ref.handleSubmit(_form, () => _update(null)) : null,
              child: const Text('Update'),
            ),
          )
        ],
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: (context, items) => _buildBody(context, items.order, items.orderItems),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OrderModel order, IList<OrderItemModel> items) {
    final fields = [
      FieldText.from(
        value: order.id,
        converter: FieldConvert.text,
        decoration: const InputDecoration(labelText: 'Id'),
      ),
      FieldDateTime.from(
        value: order.createdAt,
        decoration: const InputDecoration(labelText: 'Created At'),
      ),
      FieldDropdown(
        fieldBloc: _statusFb,
        decoration: const InputDecoration(labelText: 'Status'),
        items: OrderStatus.values.map((e) {
          return DropdownMenuItem(
            value: e,
            enabled: {
              OrderStatus.accepting,
              OrderStatus.notAccepted,
              OrderStatus.processing,
              OrderStatus.delivering,
              OrderStatus.delivered
            }.contains(e),
            child: Text(e.name),
          );
        }).toList(),
      ),
      FieldText.from(
        value: order.payer.displayName,
        converter: FieldConvert.text,
        decoration: const InputDecoration(labelText: 'Payer'),
      ),
      FieldText.from(
        value: order.payedAmount,
        converter: FieldConvert.decimalFrom(locale: Localizations.localeOf(context)),
        decoration: const InputDecoration(labelText: 'Payed Amount'),
      ),
    ];

    final products = items.map((e) {
      final imageUrl = e.product.imageUrl;
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: imageUrl != null ? CachedImage(imageUrl) : null,
              title: Text(e.product.title),
              subtitle: Text(e.product.description),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (e.ingredientsRemoved.isNotEmpty)
                  PointedList(
                    title: const Text('Ingredients Removed'),
                    children: e.ingredientsRemoved.map((e) => Text('- ${e.title}')).toList(),
                  ),
                if (e.ingredientsAdded.isNotEmpty)
                  PointedList(
                    title: const Text('Extra Ingredients'),
                    children: e.ingredientsAdded.map((e) => Text('- ${e.title}')).toList(),
                  ),
                if (e.levels.isNotEmpty)
                  PointedList(
                    title: const Text('Options'),
                    children: e.levels.mapTo((e, value) {
                      return Text('- ${e.calculateByOffset(value)} of ${e.title}');
                    }).toList(),
                  ),
              ],
            ),
          ],
        ),
      );
    }).toList();

    return AdminBodyLayout(
      slivers: [
        SliverFieldsLayout(
          children: fields,
        ),
        SliverCardsLayout(
          children: products,
        ),
      ],
    );
  }
}
