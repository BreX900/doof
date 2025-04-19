import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';

final _stateProvider = FutureProvider.autoDispose((ref) async {
  final userId = await ref.watch(UsersProviders.currentId.future);
  if (userId == null) throw MissingCredentialsFailure();

  final cart = await ref.watch(CartsProviders.public((
    Env.organizationId,
    Env.cartId,
  )).future);

  return (userId: userId, cart: cart);
});

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  AutoDisposeFutureProvider<({CartModel cart, String userId})> get _provider => _stateProvider;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final items = await ref.read(_provider.futureOfData);
    _showAlreadyInCartBanner(userId: items.userId, publicCart: items.cart);
  }

  void _showAlreadyInCartBanner({required String userId, required CartModel publicCart}) {
    if (!publicCart.members.containsId(userId)) return;

    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text('Already in ${publicCart.title} cart!'),
      actions: const [HideBannerButton()],
    ));
  }

  late final _join = ref.mutation((ref, arg) async {
    await CartsProviders.join(ref, Env.organizationId, Env.cartId);
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join in to cart'),
      ),
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
