import 'dart:async';

import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/apis/platform_utils.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/orders/utils/orders_utils.dart';
import 'package:mek_gasol/features/products/utils/purchasable_products_utils.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';

final _screenProvider = FutureProvider.autoDispose.family((ref, String orderId) async {
  final userId = await ref.watch(UsersProviders.currentId.future);
  if (userId == null) throw MissingCredentialsFailure();

  return (
    userId: userId,
    order: await ref.watch(OrdersProviders.all((
      Env.organizationId,
      whereNotStatusIn: const [],
    )).selectAsync((orders) => orders.firstWhereId(orderId))),
    orderItems: await ref.watch(OrderItemsProviders.all((Env.organizationId, orderId)).future),
  );
});

class OrderScreen extends ConsumerStatefulWidget {
  final String orderId;
  final bool isNew;

  const OrderScreen({
    super.key,
    required this.orderId,
    required this.isNew,
  });

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  AutoDisposeFutureProvider<({OrderModel order, IList<OrderItemModel> orderItems, String userId})>
      get _provider => _screenProvider(widget.orderId);

  IList<OrderItemModel>? _selection;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final data = await ref.read(_provider.futureOfData);
    if (widget.isNew) _sendMessage(data.orderItems);
  }

  late final _addItemsToCart = ref.mutation((ref, IList<OrderItemModel> items) async {
    final userId = await ref.read(UsersProviders.currentId.future);
    for (final item in items) {
      final buyer = item.buyers.singleOrNull;
      if (buyer == null || buyer.id != userId) continue;
      await CartItemsProviders.upsert(
        ref,
        Env.organizationId,
        Env.cartId,
        productId: item.product.id,
        buyers: item.buyers,
        ingredientsAdded: item.ingredientsAdded,
        ingredientsRemoved: item.ingredientsRemoved,
        levels: item.levels.map((key, value) => MapEntry(key.id, value)),
        quantity: item.quantity,
      );
    }
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onSuccess: (_, __) {
    setState(() {
      _selection = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Added to cart!'),
    ));
  });

  late final _sendMessage = ref.mutation((ref, IList<OrderItemModel> items) async {
    final message = OrdersUtils.generateMessage(items);
    await PlatformUtils.shareToWhatsApp(Env.phoneNumber, message);
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  });

  void _toggleSelection(String userId, IList<OrderItemModel> items) {
    setState(() {
      if (_selection == null) {
        _selection = items.where((e) => e.buyers.any((e) => e.id == userId)).toIList();
      } else {
        _selection = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final data = state.valueOrNull;
    final formats = AppFormats.of(context);
    final selection = _selection;

    final isIdle = !ref.watchIsMutating([_addItemsToCart, _sendMessage]);

    Widget? floatingActionButton;
    if (selection != null) {
      floatingActionButton = FloatingActionButton(
        onPressed: isIdle ? () => _addItemsToCart(selection) : null,
        child: const Icon(Icons.add_shopping_cart_outlined),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order: ${data != null ? formats.formatDate(data.order.createdAt) : '...'}'),
        actions: [
          IconButton(
            tooltip: 'Create invoice.',
            onPressed: data?.order.status == OrderStatus.accepting
                ? () => OrderInvoiceRoute(widget.orderId).go(context)
                : null,
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
          IconButton(
            tooltip: 'Send a message.',
            onPressed: isIdle && data != null ? () => _sendMessage(data.orderItems) : null,
            icon: const Icon(Icons.share),
          ),
          IconButton(
            tooltip: 'Select items to insert into cart.',
            onPressed:
                data != null ? () async => _toggleSelection(data.userId, data.orderItems) : null,
            icon: const Icon(Icons.repeat),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: (items) => _buildBody(
          context,
          ref,
          userId: items.userId,
          order: items.order,
          items: items.orderItems,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref, {
    required String userId,
    required OrderModel order,
    required IList<OrderItemModel> items,
  }) {
    final selection = _selection;
    final formats = AppFormats.of(context);

    final cartTotal = items.fold(Decimal.zero, (amount, e) => amount + e.totalCost);
    final userTotal = items
        .where((e) => e.buyers.any((e) => e.id == userId))
        .fold(Decimal.zero, (amount, e) => amount + e.individualCost);

    final header = ListTile(
      onTap: () => OrderStatRoute(order.id).go(context),
      title: Text('Your total: ${formats.formatPrice(userTotal)}'),
      subtitle: Text('Cart total: ${formats.formatPrice(cartTotal)}'),
      trailing: const Icon(Icons.attach_money),
    );

    final itemsInLists = ProductItemListTile.buildLists(
      userId: userId,
      items: items,
      builder: (context, item) {
        // ignore: avoid_positional_boolean_parameters
        void toggleItem(IList<OrderItemModel> selection, bool shouldSelected) {
          setState(() {
            _selection = shouldSelected ? selection.add(item) : selection.remove(item);
          });
        }

        Widget? trailing;
        if (selection != null && item.buyers.any((e) => e.id == userId)) {
          trailing = Checkbox(
            value: selection.contains(item),
            onChanged: (shouldSelected) => toggleItem(selection, shouldSelected!),
          );
        }
        return ProductItemListTile(
          onTap: selection == null
              ? () => ProductRoute(item.product.id, $extra: (order, item)).go(context)
              : () => toggleItem(selection, !selection.contains(item)),
          item: item,
          trailing: trailing,
        );
      },
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: header,
        ),
        const SliverToBoxAdapter(child: Divider()),
        ...itemsInLists,
      ],
    );
  }
}
