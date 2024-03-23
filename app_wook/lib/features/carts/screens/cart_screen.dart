import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/widgets/hide_banner_button.dart';

final _stateProvider = FutureProvider.autoDispose((ref) async {
  final userId = await ref.watch(UsersProviders.currentId.future);
  if (userId == null) throw MissingCredentialsFailure();

  final cart = await ref.watch(CartsProviders.public((
    Env.organizationId,
    Env.cartId,
  )).future);

  return (userId: userId, cart: cart);
});

class CartScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  CartScreen({super.key});

  late final stateProvider = _stateProvider;
  @override
  ProviderBase<void> get asyncProvider => stateProvider;

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> with AsyncConsumerState {
  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final items = await ref.read(widget.stateProvider.futureOfData);
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
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join in to cart'),
      ),
      body: state.buildView(
        data: (items) => _buildBody(items.cart),
      ),
    );
  }

  Widget _buildBody(CartModel cart) {
    final isIdle = ref.watchIdle(mutations: [_join]);

    return Center(
      child: ElevatedButton(
        onPressed: isIdle ? () => _join(null) : null,
        child: Text('Join in to "${cart.title}" cart!'),
      ),
    );
  }
}