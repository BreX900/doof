import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:pure_extensions/pure_extensions.dart';

final _stateProvider =
    FutureProvider.autoDispose.family((ref, (_StatsScreenType, String) items) async {
  final id = items.$2;

  // ignore: omit_local_variable_types
  final IList<ProductItem> productsItems = switch (items.$1) {
    _StatsScreenType.cart =>
      await ref.watch(CartItemsProviders.all((Env.organizationId, id)).future),
    _StatsScreenType.order =>
      await ref.watch(OrderItemsProviders.all((Env.organizationId, id)).future),
  };

  final buyers = productsItems.expand((element) => element.buyers).toSet();
  final buyersOrder = Map.fromEntries(buyers.map((e) {
    return MapEntry(e, productsItems.where((element) => element.buyers.contains(e)));
  }));

  return buyersOrder.generateIterable((user, products) {
    final total = products.fold(Decimal.zero, (total, product) {
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

class StatsScreen extends AsyncConsumerWidget {
  final _StatsScreenType _type;
  final String id;

  StatsScreen.fromCart({super.key})
      : _type = _StatsScreenType.cart,
        id = Env.cartId;

  StatsScreen.fromOrder({
    super.key,
    required String orderId,
  })  : _type = _StatsScreenType.order,
        id = orderId;

  late final stateProvider = _stateProvider((_type, id));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, IList<_UserStat> stats) {
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
  final Decimal total;

  const _UserStat({
    required this.user,
    required this.productsTitles,
    required this.total,
  });
}
