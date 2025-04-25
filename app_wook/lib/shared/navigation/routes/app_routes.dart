import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/carts/screens/carts_screen.dart' deferred as carts_screen;
import 'package:mek_gasol/features/orders/screens/order_checkout_screen.dart'
    deferred as order_checkout_screen;
import 'package:mek_gasol/features/orders/screens/order_screen.dart' deferred as order_screen;
import 'package:mek_gasol/features/orders/screens/orders_screen.dart' deferred as orders_screen;
import 'package:mek_gasol/features/orders/screens/stats_screen.dart' deferred as stat_screen;
import 'package:mek_gasol/features/products/screens/product_screen.dart' deferred as product_screen;
import 'package:mek_gasol/features/products/screens/products_screen.dart'
    deferred as products_screen;
import 'package:mek_gasol/features/sheet/screens/invoice_screen.dart' deferred as invoice_screen;
import 'package:mek_gasol/features/sheet/screens/invoices_screen.dart' deferred as invoices_screen;
import 'package:mek_gasol/shared/navigation/areas/user_area.dart' deferred as user_area;

part 'app_routes.g.dart';

@TypedStatefulShellRoute<UserAreaRoute>(branches: [
  TypedStatefulShellBranch(routes: [
    TypedGoRoute<InvoicesRoute>(path: '/invoices', routes: [
      TypedGoRoute<InvoiceCreateRoute>(path: 'create'),
      TypedGoRoute<InvoiceRoute>(path: ':invoiceId'),
    ]),
  ]),
  TypedStatefulShellBranch(routes: [
    TypedGoRoute<OrdersRoute>(path: '/orders', routes: [
      TypedGoRoute<OrderRoute>(path: ':orderId', routes: [
        TypedGoRoute<OrderStatRoute>(path: 'stat'),
        TypedGoRoute<OrderInvoiceRoute>(path: 'invoice'),
      ]),
    ]),
  ]),
  TypedStatefulShellBranch(routes: [
    TypedGoRoute<CartsRoute>(path: '/cart', routes: [
      TypedGoRoute<OrderCheckoutRoute>(path: 'checkout'),
      TypedGoRoute<CartStatsRoute>(path: 'stats'),
      TypedGoRoute<CartItemRoute>(path: 'items/:cartItemId'),
    ]),
  ]),
  TypedStatefulShellBranch(routes: [
    TypedGoRoute<ProductsRoute>(path: '/products', routes: [
      TypedGoRoute<ProductRoute>(path: ':productId'),
    ]),
  ]),
])
class UserAreaRoute extends StatefulShellRouteData {
  const UserAreaRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return DeferredLibraryBuilder(
      loader: user_area.loadLibrary,
      builder: (context) => user_area.UserArea(
        destinationIndex: navigationShell.currentIndex,
        onTapDestination: (index) => navigationShell.goBranch(
          index,
          initialLocation: navigationShell.currentIndex == index,
        ),
        child: navigationShell,
      ),
    );
  }
}

/// ==================== PRODUCTS

class ProductsRoute extends GoRouteData {
  const ProductsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: products_screen.loadLibrary,
      builder: (context) => products_screen.ProductsScreen(),
    );
  }
}

class ProductRoute extends GoRouteData {
  final String productId;
  // TODO: Pass a String ids
  final (OrderModel, OrderItemModel)? $extra;

  const ProductRoute(this.productId, {this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: product_screen.loadLibrary,
      builder: (context) => product_screen.ProductScreen(
        productId: productId,
        order: $extra?.$1,
        orderItem: $extra?.$2,
      ),
    );
  }
}

/// ==================== CART

class CartsRoute extends GoRouteData {
  const CartsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: carts_screen.loadLibrary,
      builder: (context) => carts_screen.CartsScreen(),
    );
  }
}

// class CartRoute extends GoRouteData {
//   const CartRoute();
//
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return DeferredLibraryBuilder(
//       loader: cart_screen.loadLibrary,
//       builder: (context) => cart_screen.CartScreen(),
//     );
//   }
// }

class CartItemRoute extends GoRouteData {
  final String cartItemId;

  const CartItemRoute(this.cartItemId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: product_screen.loadLibrary,
      builder: (context) => product_screen.ProductScreen.fromCart(cartItemId: cartItemId),
    );
  }
}

class CartStatsRoute extends GoRouteData {
  const CartStatsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: stat_screen.loadLibrary,
      builder: (context) => stat_screen.StatsScreen.fromCart(),
    );
  }
}

/// ==================== ORDER

class OrdersRoute extends GoRouteData {
  const OrdersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: orders_screen.loadLibrary,
      builder: (context) => orders_screen.OrdersScreen(),
    );
  }
}

class OrderCheckoutRoute extends GoRouteData {
  const OrderCheckoutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: order_checkout_screen.loadLibrary,
      builder: (context) => order_checkout_screen.OrderCheckoutScreen(),
    );
  }
}

class OrderRoute extends GoRouteData {
  final String orderId;
  final bool isNew;

  const OrderRoute(this.orderId, {this.isNew = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: order_screen.loadLibrary,
      builder: (context) => order_screen.OrderScreen(orderId: orderId, isNew: isNew),
    );
  }
}

class OrderStatRoute extends GoRouteData {
  final String orderId;

  const OrderStatRoute(this.orderId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: stat_screen.loadLibrary,
      builder: (context) => stat_screen.StatsScreen.fromOrder(orderId: orderId),
    );
  }
}

/// ==================== INVOICES

class InvoicesRoute extends GoRouteData {
  const InvoicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: invoices_screen.loadLibrary,
      builder: (context) => invoices_screen.InvoicesScreen(),
    );
  }
}

class InvoiceRoute extends GoRouteData {
  final String invoiceId;

  const InvoiceRoute(this.invoiceId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: invoice_screen.loadLibrary,
      builder: (context) => invoice_screen.InvoiceScreen.update(invoiceId: invoiceId),
    );
  }
}

class InvoiceCreateRoute extends GoRouteData {
  const InvoiceCreateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: invoice_screen.loadLibrary,
      builder: (context) => invoice_screen.InvoiceScreen.create(),
    );
  }
}

class OrderInvoiceRoute extends GoRouteData {
  final String orderId;

  const OrderInvoiceRoute(this.orderId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: invoice_screen.loadLibrary,
      builder: (context) => invoice_screen.InvoiceScreen.createFromOrder(orderId: orderId),
    );
  }
}
