import 'dart:async';

import 'package:app_button/features/products/widgets/product_tile.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

final _stateProvider =
    FutureProvider.autoDispose.family((ref, (String organizationId, String orderId) args) async {
  final (organizationId, orderId) = args;

  final order = await ref.watch(OrdersProviders.single((organizationId, orderId)).future);
  final orderItems = await ref.watch(OrderItemsProviders.all((organizationId, orderId)).future);

  return (order: order, orderItems: orderItems);
});

class OrderItemsScreen extends ConsumerStatefulWidget {
  final String organizationId;
  final String orderId;

  OrderItemsScreen({
    super.key,
    required this.organizationId,
    required this.orderId,
  });

  late final stateProvider = _stateProvider((organizationId, orderId));

  @override
  ConsumerState<OrderItemsScreen> createState() => _OrderItemsScreenState();
}

class _OrderItemsScreenState extends ConsumerState<OrderItemsScreen> {
  Widget _buildBody({required IList<OrderItemModel> orderItems}) {
    final formats = AppFormats.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: orderItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final item = orderItems[index];
        final product = item.product;
        final ProductModel(:imageUrl) = item.product;

        return ProductTile(
          onTap: () => unawaited(ProductRoute(widget.organizationId, product.id).push(context)),
          leading: imageUrl != null ? CachedImage(imageUrl) : null,
          title: Text(product.title),
          label: Text(product.category.title),
          subtitle: Text(formats.formatPrice(item.totalCost)),
          footers: [
            if (item.ingredientsRemoved.isNotEmpty)
              ProductParagraphTile(
                title: const Text('Removed Ingredients'),
                content: Text(item.ingredientsRemoved.map((e) => e.title).join(', ')),
              ),
            if (item.ingredientsAdded.isNotEmpty)
              ProductParagraphTile(
                title: const Text('Extra Ingredients'),
                content: Text(item.ingredientsAdded.map((e) => e.title).join(', ')),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final data = state.valueOrNull;

    final formats = AppFormats.of(context);

    return Scaffold(
      appBar: AppBar(
        title: data != null ? Text(formats.formatDateTime(data.order.createdAt)) : const DotsText(),
      ),
      body: state.buildView(
        data: (data) => _buildBody(orderItems: data.orderItems),
      ),
    );
  }
}
