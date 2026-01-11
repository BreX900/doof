import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';

final _screenProvider = FutureProvider.autoDispose.family((ref, (_StatsScreenType, String) items) {
  final id = items.$2;

  // ignore: omit_local_variable_types
  final IList<ProductItem> productsItems = switch (items.$1) {
    _StatsScreenType.cart =>
      ref.watch(CartItemsProviders.all((Env.organizationId, id))).requireValue,
    _StatsScreenType.order =>
      ref.watch(OrderItemsProviders.all((Env.organizationId, id))).requireValue,
  };

  final buyers = productsItems.expand((element) => element.buyers).toSet();
  final buyersOrder = Map.fromEntries(
    buyers.map((e) {
      return MapEntry(e, productsItems.where((element) => element.buyers.contains(e)));
    }),
  );

  return buyersOrder.mapTo((user, products) {
    final total = products.fold(Fixed.zero, (total, product) {
      return total + product.individualCost;
    });
    return _UserStat(
      user: user,
      productsTitles: products.map((e) => e.product.title).toList(),
      total: total,
    );
  }).toIList();
});

enum _StatsScreenType { cart, order }

class StatsScreen extends ConsumerStatefulWidget {
  final _StatsScreenType _type;
  final String id;

  const StatsScreen.fromCart({super.key}) : _type = _StatsScreenType.cart, id = Env.cartId;

  const StatsScreen.fromOrder({super.key, required String orderId})
    : _type = _StatsScreenType.order,
      id = orderId;

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  FutureProvider<IList<_UserStat>> get _provider => _screenProvider((widget._type, widget.id));

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: _buildBody,
      ),
    );
  }

  Widget _buildBody(IList<_UserStat> stats) {
    final formats = AppFormats.of(context);

    return ListView(
      children: stats.map((stat) {
        return ListTile(
          title: Text('${formats.formatPrice(stat.total)} - ${stat.user.displayName}'),
          subtitle: Text(stat.productsTitles.join(' - ')),
        );
      }).toList(),
    );
  }
}

class _UserStat {
  final UserDto user;
  final List<String> productsTitles;
  final Fixed total;

  const _UserStat({required this.user, required this.productsTitles, required this.total});
}
