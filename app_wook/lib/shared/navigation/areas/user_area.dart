import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/carts/screens/cart_screen.dart' deferred as cart_screen;
import 'package:mek_gasol/features/carts/screens/carts_screen.dart' deferred as carts_screen;
import 'package:mek_gasol/features/orders/screens/orders_screen.dart' deferred as orders_screen;
import 'package:mek_gasol/features/products/screens/products_screen.dart'
    deferred as products_screen;
import 'package:mek_gasol/features/sheet/screens/invoices_screen.dart' deferred as invoices_screen;

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
  const UserArea({super.key});

  static final tab = StateProvider((ref) {
    return UserAreaTab.products;
  });

  @override
  ConsumerState<UserArea> createState() => _UserAreaState();
}

class _UserAreaState extends ConsumerState<UserArea> {
  Widget _buildTab(UserAreaTab tab) {
    switch (tab) {
      case UserAreaTab.invoices:
        return DeferredLibraryBuilder(
          loader: invoices_screen.loadLibrary,
          builder: (context) => invoices_screen.InvoicesScreen(),
        );
      case UserAreaTab.orders:
        return DeferredLibraryBuilder(
          loader: orders_screen.loadLibrary,
          builder: (context) => orders_screen.OrdersScreen(),
        );
      case UserAreaTab.products:
        return DeferredLibraryBuilder(
          loader: products_screen.loadLibrary,
          builder: (context) => products_screen.ProductsScreen(),
        );
      case UserAreaTab.carts:
        return DeferredLibraryBuilder(
          loader: carts_screen.loadLibrary,
          builder: (context) => carts_screen.CartsScreen(),
        );
    }
  }

  BottomNavigationBarItem _buildBottomBarItem(UserAreaTab tab) {
    switch (tab) {
      case UserAreaTab.invoices:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.folder_copy_outlined),
          label: 'Invoices',
        );
      case UserAreaTab.orders:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: 'Orders',
        );
      case UserAreaTab.products:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.fastfood_outlined),
          label: 'Menu',
        );
      case UserAreaTab.carts:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        );
    }
  }

  Widget _buildNavigationBarItem(UserAreaTab tab) {
    switch (tab) {
      case UserAreaTab.invoices:
        return const NavigationDestination(
          icon: Icon(Icons.folder_copy_outlined),
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

  Widget _buildBottomNavigationBar(WidgetRef ref, UserAreaTab tab) {
    return BottomNavigationBar(
      currentIndex: tab.index,
      onTap: (index) => ref.read(UserArea.tab.notifier).state = UserAreaTab.values[index],
      items: UserAreaTab.values.map(_buildBottomBarItem).toList(),
    );
  }

  Widget _buildNavigationBar(WidgetRef ref, UserAreaTab tab) {
    return NavigationBar(
      selectedIndex: tab.index,
      onDestinationSelected: (index) =>
          ref.read(UserArea.tab.notifier).state = UserAreaTab.values[index],
      destinations: UserAreaTab.values.map(_buildNavigationBarItem).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(UserArea.tab);
    final state = ref.watch(_areaProvider);

    final theme = Theme.of(context);

    return state.buildView(data: (shouldJoinInCart) {
      if (shouldJoinInCart) {
        return DeferredLibraryBuilder(
          loader: cart_screen.loadLibrary,
          builder: (context) => cart_screen.CartScreen(),
        );
      }

      return Scaffold(
        bottomNavigationBar: theme.useMaterial3
            ? _buildNavigationBar(ref, tab)
            : _buildBottomNavigationBar(ref, tab),
        body: IndexedStack(
          index: tab.index,
          children: UserAreaTab.values.map(_buildTab).toList(),
        ),
      );
    });
  }
}
