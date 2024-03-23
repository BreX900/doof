// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $userAreaRoute,
    ];

RouteBase get $userAreaRoute => GoRouteData.$route(
      path: '/',
      factory: $UserAreaRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'products/:productId',
          factory: $ProductRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'orders/:orderId',
          factory: $OrdersRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'stat',
              factory: $OrderStatRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'invoice',
              factory: $OrderInvoiceRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'cart',
          factory: $CartRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'cart/stat',
          factory: $CartStatsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'carts/checkout',
          factory: $OrderCheckoutRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'carts/items/:cartItemId',
          factory: $CartItemRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'invoices/:invoiceId',
          factory: $InvoiceRouteExtension._fromState,
        ),
      ],
    );

extension $UserAreaRouteExtension on UserAreaRoute {
  static UserAreaRoute _fromState(GoRouterState state) => const UserAreaRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductRouteExtension on ProductRoute {
  static ProductRoute _fromState(GoRouterState state) => ProductRoute(
        state.pathParameters['productId']!,
        $extra: state.extra as (OrderModel, OrderItemModel)?,
      );

  String get location => GoRouteData.$location(
        '/products/${Uri.encodeComponent(productId)}',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $OrdersRouteExtension on OrdersRoute {
  static OrdersRoute _fromState(GoRouterState state) => OrdersRoute(
        state.pathParameters['orderId']!,
      );

  String get location => GoRouteData.$location(
        '/orders/${Uri.encodeComponent(orderId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrderStatRouteExtension on OrderStatRoute {
  static OrderStatRoute _fromState(GoRouterState state) => OrderStatRoute(
        state.pathParameters['orderId']!,
      );

  String get location => GoRouteData.$location(
        '/orders/${Uri.encodeComponent(orderId)}/stat',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrderInvoiceRouteExtension on OrderInvoiceRoute {
  static OrderInvoiceRoute _fromState(GoRouterState state) => OrderInvoiceRoute(
        state.pathParameters['orderId']!,
      );

  String get location => GoRouteData.$location(
        '/orders/${Uri.encodeComponent(orderId)}/invoice',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartRouteExtension on CartRoute {
  static CartRoute _fromState(GoRouterState state) => const CartRoute();

  String get location => GoRouteData.$location(
        '/cart',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartStatsRouteExtension on CartStatsRoute {
  static CartStatsRoute _fromState(GoRouterState state) =>
      const CartStatsRoute();

  String get location => GoRouteData.$location(
        '/cart/stat',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrderCheckoutRouteExtension on OrderCheckoutRoute {
  static OrderCheckoutRoute _fromState(GoRouterState state) =>
      const OrderCheckoutRoute();

  String get location => GoRouteData.$location(
        '/carts/checkout',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartItemRouteExtension on CartItemRoute {
  static CartItemRoute _fromState(GoRouterState state) => CartItemRoute(
        state.pathParameters['cartItemId']!,
      );

  String get location => GoRouteData.$location(
        '/carts/items/${Uri.encodeComponent(cartItemId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $InvoiceRouteExtension on InvoiceRoute {
  static InvoiceRoute _fromState(GoRouterState state) => InvoiceRoute(
        state.pathParameters['invoiceId']!,
      );

  String get location => GoRouteData.$location(
        '/invoices/${Uri.encodeComponent(invoiceId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
