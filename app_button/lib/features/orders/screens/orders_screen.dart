import 'package:app_button/apis/riverpod/riverpod_utils.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:app_button/shared/widgets/app_info_view.dart';
import 'package:app_button/shared/widgets/store_drawer.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.family((ref, (String organizationId,) arg) async {
  final (organizationId,) = arg;

  final organization = await ref.watch(OrganizationsProviders.single(organizationId).future);
  final orders = await ref.watch(
    OrdersProviders.all((organizationId, whereNotStatusIn: [])).future,
  );

  return (organization: organization, orders: orders);
});

class OrdersScreen extends ConsumerStatefulWidget {
  final String organizationId;

  OrdersScreen({super.key, required this.organizationId});

  late final stateProvider = _stateProvider((organizationId,));

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  Widget _buildBody({required IList<OrderModel> orders}) {
    final formats = AppFormats.of(context);

    if (orders.isEmpty) {
      return AppInfoView(
        header: SvgPicture.asset(R.svgsCartEmpty),
        title: const Text('Lista vuota'),
        subtitle: const Text('aggiungi un prodotto al tuo carrello dal menu'),
        action: ElevatedButton(
          onPressed: () => ProductsRoute(widget.organizationId).go(context),
          child: const Text('ORDINA ORA'),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return ListTile(
          onTap: () => OrderItemsRoute(widget.organizationId, order.id).go(context),
          title: Text(formats.formatDateTime(order.createdAt)),
          subtitle: Text(order.status.translate(shippable: order.shippable)),
          trailing: Text(formats.formatPrice(order.payedAmount)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final data = state.value;

    return Scaffold(
      drawer: StoreDrawer(organizationId: widget.organizationId),
      appBar: AppBar(title: DotsText.or(data?.organization.name)),
      body: state.buildView(
        onRefresh: () {},
        data: (data) => _buildBody(orders: data.orders),
      ),
    );
  }
}
