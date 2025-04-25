// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $userAreaRoute,
    ];

RouteBase get $userAreaRoute => StatefulShellRouteData.$route(
      factory: $UserAreaRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/invoices',
              factory: $InvoicesRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'create',
                  factory: $InvoiceCreateRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: ':invoiceId',
                  factory: $InvoiceRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/orders',
              factory: $OrdersRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':orderId',
                  factory: $OrderRouteExtension._fromState,
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
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/cart',
              factory: $CartsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'checkout',
                  factory: $OrderCheckoutRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'stats',
                  factory: $CartStatsRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'items/:cartItemId',
                  factory: $CartItemRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/products',
              factory: $ProductsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':productId',
                  factory: $ProductRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $UserAreaRouteExtension on UserAreaRoute {
  static UserAreaRoute _fromState(GoRouterState state) => const UserAreaRoute();
}

extension $InvoicesRouteExtension on InvoicesRoute {
  static InvoicesRoute _fromState(GoRouterState state) => const InvoicesRoute();

  String get location => GoRouteData.$location(
        '/invoices',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $InvoiceCreateRouteExtension on InvoiceCreateRoute {
  static InvoiceCreateRoute _fromState(GoRouterState state) =>
      const InvoiceCreateRoute();

  String get location => GoRouteData.$location(
        '/invoices/create',
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

extension $OrdersRouteExtension on OrdersRoute {
  static OrdersRoute _fromState(GoRouterState state) => const OrdersRoute();

  String get location => GoRouteData.$location(
        '/orders',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrderRouteExtension on OrderRoute {
  static OrderRoute _fromState(GoRouterState state) => OrderRoute(
        state.pathParameters['orderId']!,
        isNew: _$convertMapValue(
                'is-new', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  String get location => GoRouteData.$location(
        '/orders/${Uri.encodeComponent(orderId)}',
        queryParams: {
          if (isNew != false) 'is-new': isNew.toString(),
        },
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

extension $CartsRouteExtension on CartsRoute {
  static CartsRoute _fromState(GoRouterState state) => const CartsRoute();

  String get location => GoRouteData.$location(
        '/cart',
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
        '/cart/checkout',
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
        '/cart/stats',
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
        '/cart/items/${Uri.encodeComponent(cartItemId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductsRouteExtension on ProductsRoute {
  static ProductsRoute _fromState(GoRouterState state) => const ProductsRoute();

  String get location => GoRouteData.$location(
        '/products',
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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
