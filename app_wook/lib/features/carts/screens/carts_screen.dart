import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/products/utils/purchasable_products_utils.dart';
import 'package:mek_gasol/shared/navigation/areas/user_area.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';

final _stateProvider = FutureProvider.autoDispose((ref) async {
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

class CartsScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  CartsScreen({super.key});

  late final stateProvider = _stateProvider;

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends ConsumerState<CartsScreen> with AsyncConsumerState {
  late final _removeItem = ref.mutation((ref, (CartModel cart, CartItemModel item) args) async {
    final (cart, item) = args;
    await CartItemsProviders.remove(ref, cart.id, item.id);
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final carts = state.valueOrNull?.productsInCarts ?? const IMapConst({});

    final Widget child = Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: (context, items) => _buildBody(
          context,
          ref,
          userId: items.userId,
          carts: items.productsInCarts,
        ),
      ),
    );

    return DefaultTabController(
      length: carts.length,
      child: child,
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref, {
    required String? userId,
    required IMap<CartModel, IList<CartItemModel>> carts,
  }) {
    final isIdle = ref.watchIdle(mutations: [_removeItem]);

    final tabController = DefaultTabController.of(context);
    final formats = AppFormats.of(context);

    final tabIndex = ref.watch(tabController.pick((listenable) => listenable.index));
    final cartEntry = carts.entries.elementAt(tabIndex);
    final cart = cartEntry.key;
    final items = cartEntry.value;
    final cartTotal = items.fold(Decimal.zero, (amount, e) => amount + e.totalCost);
    final userTotal = items
        .where((e) => e.buyers.any((e) => e.id == userId))
        .fold(Decimal.zero, (amount, e) => amount + e.individualCost);

    if (items.isEmpty) {
      return InfoTile(
        onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.products,
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
      child: ElevatedButton.icon(
        onPressed: () => const OrderCheckoutRoute().go(context),
        icon: const Icon(Icons.send),
        label: const Text('Order'),
      ),
    );

    final itemsInLists = ProductItemListTile.buildLists(
      userId: userId,
      items: items,
      builder: (context, item) {
        return ProductItemListTile(
          onTap: () => CartItemRoute(item.id).go(context),
          item: item,
          trailing: PopupMenuButton(
            enabled: isIdle,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => _removeItem((cart, item)),
                child: const ListTile(
                  title: Text('Delete'),
                  leading: Icon(Icons.delete),
                ),
              ),
            ],
          ),
        );
      },
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: header,
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
          sliver: SliverToBoxAdapter(
            child: buttons,
          ),
        ),
        ...itemsInLists,
      ],
    );
  }
}
