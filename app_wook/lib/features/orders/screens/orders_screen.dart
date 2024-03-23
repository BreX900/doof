import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/navigation/areas/user_area.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class OrdersScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  OrdersScreen({super.key});

  late final stateProvider = OrdersProviders.all((
    Env.organizationId,
    whereNotStatusIn: const [],
  ));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with AsyncConsumerState {
  late final _deleteOrder = ref.mutation((ref, OrderModel order) async {
    await OrdersProviders.delete(ref, Env.organizationId, order);
  });

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(widget.stateProvider);

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
      body: AsyncViewBuilder(
        state: orders,
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, IList<OrderModel> orders) {
    if (orders.isEmpty) {
      return Consumer(builder: (context, ref, _) {
        return InfoTile(
          onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.carts,
          title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carrello! 🛒'),
        );
      });
    }

    final isIdle = ref.watchIdle(mutations: [_deleteOrder]);
    final formats = AppFormats.of(context);

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return ListTile(
          onTap: () => OrdersRoute(order.id).go(context),
          title: Text('${formats.formatDateTime(order.createdAt)}  Status: ${order.status.name}'),
          subtitle: Text('Total: ${formats.formatPrice(order.payedAmount)}'),
          trailing: PopupMenuButton(
            enabled: isIdle,
            itemBuilder: (context) {
              return [
                if (order.status == OrderStatus.accepting)
                  PopupMenuItem(
                    onTap: () => _deleteOrder(order),
                    child: const ListTile(
                      title: Text('Delete'),
                      leading: Icon(Icons.delete),
                    ),
                  ),
              ];
            },
          ),
        );
      },
    );
  }
}
