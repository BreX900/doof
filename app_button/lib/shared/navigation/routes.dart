import 'package:app_button/features/carts/screens/cart_checkout_screen.dart'
    deferred as cart_checkout_screen;
import 'package:app_button/features/carts/screens/cart_screen.dart' deferred as carts_screen;
import 'package:app_button/features/orders/screens/order_items_screen.dart'
    deferred as order_items_screen;
import 'package:app_button/features/orders/screens/orders_screen.dart' deferred as orders_screen;
import 'package:app_button/features/products/screens/product_screen.dart'
    deferred as product_screen;
import 'package:app_button/features/products/screens/products_screen.dart'
    deferred as products_screen;
import 'package:app_button/features/qr_code/screens/qr_code_screen.dart' deferred as qr_code_screen;
import 'package:app_button/features/tickets/screens/ticket_create_screen.dart'
    deferred as place_upsert_screen;
import 'package:app_button/features/tickets/screens/ticket_created_screen.dart'
    deferred as place_sent_screen;
import 'package:app_button/features/users/screens/services_screen.dart' deferred as services_screen;
import 'package:app_button/features/users/screens/sign_in_phone_number_screen.dart'
    deferred as sign_in_phone_number_screen;
import 'package:app_button/shared/navigation/areas/store_bottom_bar.dart'
    deferred as store_bottom_bar;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

part 'routes.g.dart';

@TypedGoRoute<QrCodeRoute>(path: '/')
class QrCodeRoute extends GoRouteData {
  const QrCodeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: qr_code_screen.loadLibrary,
      builder: (context) => qr_code_screen.QrCodeScreen(),
    );
  }
}

@TypedGoRoute<ServicesRoute>(
  path: '/services/:organizationId',
  routes: [
    TypedGoRoute<TicketCreateRoute>(path: 'table-service'),
    TypedGoRoute<TicketCreatedRoute>(path: 'table-service-requested'),
  ],
)
class ServicesRoute extends GoRouteData {
  final String organizationId;

  const ServicesRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: services_screen.loadLibrary,
      builder: (context) => services_screen.ServicesScreen(organizationId: organizationId),
    );
  }
}

class TicketCreateRoute extends GoRouteData {
  final String organizationId;

  const TicketCreateRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: place_upsert_screen.loadLibrary,
      builder: (context) => place_upsert_screen.TicketCreateScreen(organizationId: organizationId),
    );
  }
}

class TicketCreatedRoute extends GoRouteData {
  final String organizationId;

  const TicketCreatedRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: place_sent_screen.loadLibrary,
      builder: (context) => place_sent_screen.TicketCreatedScreen(organizationId: organizationId),
    );
  }
}

@TypedGoRoute<SignInPhoneNumberRoute>(path: '/sign-in')
class SignInPhoneNumberRoute extends GoRouteData {
  final String? organizationId;
  final String? verificationId;
  final bool shouldPop;

  const SignInPhoneNumberRoute({this.organizationId, this.verificationId, this.shouldPop = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: sign_in_phone_number_screen.loadLibrary,
      builder: (context) => sign_in_phone_number_screen.SignInPhoneNumberScreen(
        organizationId: organizationId,
        verificationId: verificationId,
        shouldPop: shouldPop,
      ),
    );
  }
}

@TypedShellRoute<StoreRoute>(
  routes: [
    TypedGoRoute<ProductsRoute>(
      path: '/store/:organizationId/products',
      routes: [TypedGoRoute<ProductRoute>(path: ':productId')],
    ),
    TypedGoRoute<CartRoute>(
      path: '/store/:organizationId/cart',
      routes: [
        TypedGoRoute<CartCheckoutRoute>(path: 'checkout'),
        TypedGoRoute<CartItemRoute>(path: ':itemId'),
      ],
    ),
    TypedGoRoute<OrdersRoute>(
      path: '/store/:organizationId/orders',
      routes: [TypedGoRoute<OrderItemsRoute>(path: ':orderId')],
    ),
  ],
)
class StoreRoute extends ShellRouteData {
  const StoreRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    final info = GoRouter.of(context).routeInformationProvider.value;
    if (!info.uri.path.startsWith('/store/')) return navigator;

    final organizationId = state.pathParameters['organizationId']!;

    return DeferredLibraryBuilder(
      loader: store_bottom_bar.loadLibrary,
      builder: (context) => Scaffold(
        bottomNavigationBar: store_bottom_bar.StoreBottomBar(organizationId: organizationId),
        body: navigator,
      ),
    );
  }
}

class ProductsRoute extends GoRouteData {
  final String organizationId;

  const ProductsRoute(this.organizationId);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: products_screen.loadLibrary,
      builder: (context) => products_screen.ProductsScreen(organizationId: organizationId),
    );
  }
}

class ProductRoute extends GoRouteData {
  final String organizationId;
  final String productId;

  const ProductRoute(this.organizationId, this.productId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: product_screen.loadLibrary,
      builder: (context) =>
          product_screen.ProductScreen(organizationId: organizationId, productId: productId),
    );
  }
}

class CartRoute extends GoRouteData {
  final String organizationId;

  const CartRoute(this.organizationId);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: carts_screen.loadLibrary,
      builder: (context) => carts_screen.CartScreen(organizationId: organizationId),
    );
  }
}

class CartItemRoute extends GoRouteData {
  final String organizationId;
  final String itemId;

  const CartItemRoute(this.organizationId, this.itemId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: product_screen.loadLibrary,
      builder: (context) =>
          product_screen.ProductScreen.fromCart(organizationId: organizationId, itemId: itemId),
    );
  }
}

class CartCheckoutRoute extends GoRouteData {
  final String organizationId;

  const CartCheckoutRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: cart_checkout_screen.loadLibrary,
      builder: (context) => cart_checkout_screen.CartCheckoutScreen(organizationId: organizationId),
    );
  }
}

class OrdersRoute extends GoRouteData {
  final String organizationId;

  const OrdersRoute(this.organizationId);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: orders_screen.loadLibrary,
      builder: (context) => orders_screen.OrdersScreen(organizationId: organizationId),
    );
  }
}

class OrderItemsRoute extends GoRouteData {
  final String organizationId;
  final String orderId;

  const OrderItemsRoute(this.organizationId, this.orderId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: order_items_screen.loadLibrary,
      builder: (context) =>
          order_items_screen.OrderItemsScreen(organizationId: organizationId, orderId: orderId),
    );
  }
}
