import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/navigation/areas/user_area.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  StreamProvider<IList<OrderModel>> get _provider => OrdersProviders.all((
        Env.organizationId,
        whereNotStatusIn: const [],
      ));

  late final _cancelOrder = ref.mutation((ref, OrderModel order) async {
    final items = await ref.read(OrderItemsProviders.all((Env.organizationId, order.id)).future);
    await CartItemsProviders.upsertFromOrder(ref, Env.organizationId, Env.cartId, items);

    await OrdersProviders.delete(ref, Env.organizationId, order);
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  });

  late final _deleteOrder = ref.mutation((ref, OrderModel order) async {
    await OrdersProviders.delete(ref, Env.organizationId, order);
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  });

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Orders'),
        // actions: [
        // IconButton(
        //   onPressed: () => context.nav.push(const MatchQueueScreen()),
        //   icon: const Icon(Icons.sports_football_outlined),
        // ),
        // ],
      ),
      body: orders.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: _buildBody,
      ),
    );
  }

  Widget _buildBody(IList<OrderModel> orders) {
    if (orders.isEmpty) {
      return Consumer(builder: (context, ref, _) {
        return InfoView(
          onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.carts,
          title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carrello! 🛒'),
        );
      });
    }

    final isMutating = ref.watchIsMutating([_deleteOrder]);
    final formats = AppFormats.of(context);

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Dismissible(
          key: ValueKey(order.id),
          onDismissed: isMutating
              ? (direction) => switch (direction) {
                    DismissDirection.startToEnd => _cancelOrder(order),
                    DismissDirection.endToStart => _deleteOrder(order),
                    _ => null,
                  }
              : null,
          background: const DismissingTile.left(
            secondary: Icon(Icons.cancel),
            title: Text('Cancel'),
            subtitle: Text('Add items to cart'),
          ),
          secondaryBackground: const DismissingTile.right(
            secondary: Icon(Icons.delete),
            title: Text('Delete'),
          ),
          child: ListTile(
            onTap: () => OrderRoute(order.id).go(context),
            title: Text('${formats.formatDateTime(order.createdAt)}  Status: ${order.status.name}'),
            subtitle: Text('Total: ${formats.formatPrice(order.payedAmount)}'),
          ),
        );
      },
    );
  }
}
