import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/carts/screens/cart_screen.dart' deferred as cart_screen;
import 'package:mek_gasol/features/orders/screens/order_checkout_screen.dart'
    deferred as order_checkout_screen;
import 'package:mek_gasol/features/orders/screens/order_screen.dart' deferred as order_screen;
import 'package:mek_gasol/features/orders/screens/stats_screen.dart' deferred as stat_screen;
import 'package:mek_gasol/features/products/screens/product_screen.dart' deferred as product_screen;
import 'package:mek_gasol/features/sheet/screens/invoice_screen.dart' deferred as invoice_screen;
import 'package:mek_gasol/features/sheet/screens/invoices_screen.dart' deferred as invoices_screen;
import 'package:mek_gasol/shared/navigation/areas/user_area.dart' deferred as user_area;

part 'app_routes.g.dart';

@TypedGoRoute<UserAreaRoute>(path: '/', routes: [
  TypedGoRoute<ProductRoute>(path: 'products/:productId'),
  TypedGoRoute<OrderRoute>(path: 'orders/:orderId', routes: [
    TypedGoRoute<OrderStatRoute>(path: 'stat'),
    TypedGoRoute<OrderInvoiceRoute>(path: 'invoice'),
  ]),
  TypedGoRoute<CartRoute>(path: 'cart'),
  TypedGoRoute<CartStatsRoute>(path: 'cart/stat'),
  TypedGoRoute<OrderCheckoutRoute>(path: 'carts/checkout'),
  TypedGoRoute<CartItemRoute>(path: 'carts/items/:cartItemId'),
  TypedGoRoute<InvoiceCreateRoute>(path: 'invoices/create'),
  TypedGoRoute<InvoiceRoute>(path: 'invoices/:invoiceId'),
])
class UserAreaRoute extends GoRouteData {
  const UserAreaRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: user_area.loadLibrary,
      builder: (context) => user_area.UserArea(),
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

class CartRoute extends GoRouteData {
  const CartRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: cart_screen.loadLibrary,
      builder: (context) => cart_screen.CartScreen(),
    );
  }
}

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
      builder: (context) => invoice_screen.InvoiceScreen(),
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
      builder: (context) => invoice_screen.InvoiceScreen.fromOrder(orderId: orderId),
    );
  }
}
