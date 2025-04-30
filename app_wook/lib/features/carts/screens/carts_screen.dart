import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/products/utils/purchasable_products_utils.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';

final _screenProvider = FutureProvider.autoDispose((ref) async {
  final userId = await ref.watch(UsersProviders.currentId.future);
  if (userId == null) throw MissingCredentialsFailure();

  final cart = await ref.watch(CartsProviders.public((
    Env.organizationId,
    Env.cartId,
  )).future);

  final productsInCarts = {
    for (final cart in [cart])
      cart: await ref.watch(CartItemsProviders.all((Env.organizationId, cart.id)).future),
  }.toIMap();

  return (userId: userId, productsInCarts: productsInCarts);
});

class CartsScreen extends ConsumerStatefulWidget {
  const CartsScreen({super.key});

  @override
  ConsumerState<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends ConsumerState<CartsScreen> {
  AutoDisposeFutureProvider<
          ({IMap<CartModel, IList<CartItemModel>> productsInCarts, String userId})>
      get _provider => _screenProvider;

  var _pendingItems = const ISet<(String, String)>.empty();

  late final _removeItem = ref.mutation((ref, (CartModel cart, CartItemModel item) __) async {
    final (cart, item) = __;
    setState(() => _pendingItems = _pendingItems.add((cart.id, item.id)));
    await CartItemsProviders.remove(ref, cart.id, item.id);
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onFinish: (__, _, ___) {
    final (cart, item) = __;
    setState(() => _pendingItems = _pendingItems.remove((cart.id, item.id)));
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final carts = state.valueOrNull?.productsInCarts ?? const IMapConst({});

    final Widget child = Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: (data) => _CartsBody(
          state: this,
          userId: data.userId,
          carts: data.productsInCarts.map((cart, items) {
            return MapEntry(
              cart,
              items.where((item) => !_pendingItems.contains((cart.id, item.id))).toIList(),
            );
          }),
        ),
      ),
    );

    return DefaultTabController(
      length: carts.length,
      child: child,
    );
  }
}

class _CartsBody extends ConsumerWidget {
  final _CartsScreenState state;
  final String? userId;
  final IMap<CartModel, IList<CartItemModel>> carts;

  const _CartsBody({required this.state, required this.userId, required this.carts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMutating = ref.watchIsMutating([state._removeItem]);

    final tabController = DefaultTabController.of(context);
    final formats = AppFormats.of(context);

    final tabIndex = ref.watch(tabController.provider.index);
    final cartEntry = carts.entries.elementAt(tabIndex);
    final cart = cartEntry.key;
    final items = cartEntry.value;
    final cartTotal = items.fold(Decimal.zero, (amount, e) => amount + e.totalCost);
    final userTotal = items
        .where((e) => e.buyers.any((e) => e.id == userId))
        .fold(Decimal.zero, (amount, e) => amount + e.individualCost);

    if (items.isEmpty) {
      return InfoView(
        onTap: () => const ProductsRoute().go(context),
        title: const Text('😱 Non ci sono prodotti nel carrello! 😱\n🍾 Vai al menu! 🥙'),
      );
    }

    final header = ListTile(
      onTap: () => const CartStatsRoute().go(context),
      title: Text('Your total: ${formats.formatPrice(userTotal)}'),
      subtitle: Text('Cart total: ${formats.formatPrice(cartTotal)}'),
      trailing: const Icon(Icons.attach_money),
    );

    final buttons = SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => const OrderCheckoutRoute().go(context),
        icon: const Icon(Icons.send),
        label: const Text('Order'),
      ),
    );

    final itemsInLists = ProductItemListTile.buildLists(
      userId: userId,
      items: items.unlockView,
      builder: (context, item) => Dismissible(
        key: ValueKey(item),
        onDismissed: !isMutating ? (_) => state._removeItem((cart, item)) : null,
        child: ProductItemListTile(
          onTap: () => CartItemRoute(item.id).go(context),
          item: item,
        ),
      ),
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: header,
        ),
        SliverPersistentSizeHeader(
          pinned: true,
          floating: true,
          height: 56.0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buttons,
            ),
          ),
        ),
        ...itemsInLists,
      ],
    );
  }
}
