import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/carts/screens/cart_screen.dart' deferred as cart_screen;
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';

final _areaProvider = FutureProvider((ref) async {
  final userId = await ref.watch(UsersProviders.currentId.future);
  if (userId == null) throw MissingCredentialsFailure();

  final cart = await ref.watch(CartsProviders.public((
    Env.organizationId,
    Env.cartId,
  )).future);

  return cart.members.every((e) => e.id != userId);
});

enum UserAreaTab { invoices, orders, carts, products }

class UserArea extends ConsumerStatefulWidget {
  final ValueChanged<int> onTapDestination;
  final int destinationIndex;
  final Widget child;

  const UserArea({
    super.key,
    required this.onTapDestination,
    required this.destinationIndex,
    required this.child,
  });

  static final tab = StateProvider((ref) {
    return UserAreaTab.products;
  });

  @override
  ConsumerState<UserArea> createState() => _UserAreaState();
}

class _UserAreaState extends ConsumerState<UserArea> {
  FutureProvider<bool> get _provider => _areaProvider;

  Widget _buildNavigationBarItem(UserAreaTab tab) {
    switch (tab) {
      case UserAreaTab.invoices:
        return const NavigationDestination(
          icon: Icon(Icons.receipt_long),
          label: 'Invoices',
        );
      case UserAreaTab.orders:
        return const NavigationDestination(
          icon: Icon(Icons.library_books_outlined),
          label: 'Orders',
        );
      case UserAreaTab.products:
        return const NavigationDestination(
          icon: Icon(Icons.fastfood_outlined),
          label: 'Menu',
        );
      case UserAreaTab.carts:
        return const NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        );
    }
  }

  Widget _buildNavigationBar(WidgetRef ref, UserAreaTab tab) {
    return NavigationBar(
      selectedIndex: widget.destinationIndex,
      onDestinationSelected: widget.onTapDestination,
      destinations: UserAreaTab.values.map(_buildNavigationBarItem).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(UserArea.tab);
    final state = ref.watch(_provider);

    return state.buildView(
      onRefresh: () => ref.invalidateWithAncestors(_provider),
      data: (shouldJoinInCart) {
        if (shouldJoinInCart) {
          return DeferredLibraryBuilder(
            loader: cart_screen.loadLibrary,
            builder: (context) => cart_screen.CartScreen(),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: widget.child,
          bottomNavigationBar: _buildNavigationBar(ref, tab),
        );
      },
    );
  }
}
