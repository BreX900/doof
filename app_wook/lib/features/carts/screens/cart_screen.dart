import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';

final _stateProvider = FutureProvider.autoDispose((ref) {
  final userId = ref.watch(UsersProviders.currentId).requireValue;
  if (userId == null) throw MissingCredentialsFailure();

  final cartState = ref.watch(CartsProviders.public((Env.organizationId, Env.cartId)));

  return (userId: userId, cart: cartState.requireValue);
});

class CartScreen extends SourceConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  SourceConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends SourceConsumerState<CartScreen> {
  FutureProvider<({CartModel cart, String userId})> get _provider => _stateProvider;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final items = await ref.futureOfData(_provider);
    _showAlreadyInCartBanner(userId: items.userId, publicCart: items.cart);
  }

  void _showAlreadyInCartBanner({required String userId, required CartModel publicCart}) {
    if (!publicCart.members.containsId(userId)) return;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text('Already in ${publicCart.title} cart!'),
        actions: const [HideBannerButton()],
      ),
    );
  }

  late final _join = ref.mutation(
    (ref, arg) async => await CartsProviders.join(ref, Env.organizationId, Env.cartId),
    onError: (_, error) => CoreUtils.showErrorSnackBar(context, error),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(title: const Text('Join in to cart')),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: (items) => _buildBody(items.cart),
      ),
    );
  }

  Widget _buildBody(CartModel cart) {
    final isIdle = !ref.watchIsMutating([_join]);

    return Center(
      child: ElevatedButton(
        onPressed: isIdle ? () => _join(null) : null,
        child: Text('Join in to "${cart.title}" cart!'),
      ),
    );
  }
}
