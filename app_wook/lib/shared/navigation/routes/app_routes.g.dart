// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, cast_nullable_to_non_nullable

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$userAreaRoute];

RouteBase get $userAreaRoute => StatefulShellRouteData.$route(
  factory: $UserAreaRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/invoices',
          factory: $InvoicesRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'create',
              factory: $InvoiceCreateRoute._fromState,
            ),
            GoRouteData.$route(
              path: ':invoiceId',
              factory: $InvoiceRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/orders',
          factory: $OrdersRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':orderId',
              factory: $OrderRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'stat',
                  factory: $OrderStatRoute._fromState,
                ),
                GoRouteData.$route(
                  path: 'invoice',
                  factory: $OrderInvoiceRoute._fromState,
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
          factory: $CartsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'checkout',
              factory: $OrderCheckoutRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'stats',
              factory: $CartStatsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'items/:cartItemId',
              factory: $CartItemRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/products',
          factory: $ProductsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':productId',
              factory: $ProductRoute._fromState,
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

mixin $InvoicesRoute on GoRouteData {
  static InvoicesRoute _fromState(GoRouterState state) => const InvoicesRoute();

  @override
  String get location => GoRouteData.$location('/invoices');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $InvoiceCreateRoute on GoRouteData {
  static InvoiceCreateRoute _fromState(GoRouterState state) =>
      const InvoiceCreateRoute();

  @override
  String get location => GoRouteData.$location('/invoices/create');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $InvoiceRoute on GoRouteData {
  static InvoiceRoute _fromState(GoRouterState state) =>
      InvoiceRoute(state.pathParameters['invoiceId']!);

  InvoiceRoute get _self => this as InvoiceRoute;

  @override
  String get location => GoRouteData.$location(
    '/invoices/${Uri.encodeComponent(_self.invoiceId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrdersRoute on GoRouteData {
  static OrdersRoute _fromState(GoRouterState state) => const OrdersRoute();

  @override
  String get location => GoRouteData.$location('/orders');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderRoute on GoRouteData {
  static OrderRoute _fromState(GoRouterState state) => OrderRoute(
    state.pathParameters['orderId']!,
    isNew:
        _$convertMapValue(
          'is-new',
          state.uri.queryParameters,
          _$boolConverter,
        ) ??
        false,
  );

  OrderRoute get _self => this as OrderRoute;

  @override
  String get location => GoRouteData.$location(
    '/orders/${Uri.encodeComponent(_self.orderId)}',
    queryParams: {if (_self.isNew != false) 'is-new': _self.isNew.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderStatRoute on GoRouteData {
  static OrderStatRoute _fromState(GoRouterState state) =>
      OrderStatRoute(state.pathParameters['orderId']!);

  OrderStatRoute get _self => this as OrderStatRoute;

  @override
  String get location => GoRouteData.$location(
    '/orders/${Uri.encodeComponent(_self.orderId)}/stat',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderInvoiceRoute on GoRouteData {
  static OrderInvoiceRoute _fromState(GoRouterState state) =>
      OrderInvoiceRoute(state.pathParameters['orderId']!);

  OrderInvoiceRoute get _self => this as OrderInvoiceRoute;

  @override
  String get location => GoRouteData.$location(
    '/orders/${Uri.encodeComponent(_self.orderId)}/invoice',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CartsRoute on GoRouteData {
  static CartsRoute _fromState(GoRouterState state) => const CartsRoute();

  @override
  String get location => GoRouteData.$location('/cart');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderCheckoutRoute on GoRouteData {
  static OrderCheckoutRoute _fromState(GoRouterState state) =>
      const OrderCheckoutRoute();

  @override
  String get location => GoRouteData.$location('/cart/checkout');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CartStatsRoute on GoRouteData {
  static CartStatsRoute _fromState(GoRouterState state) =>
      const CartStatsRoute();

  @override
  String get location => GoRouteData.$location('/cart/stats');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CartItemRoute on GoRouteData {
  static CartItemRoute _fromState(GoRouterState state) =>
      CartItemRoute(state.pathParameters['cartItemId']!);

  CartItemRoute get _self => this as CartItemRoute;

  @override
  String get location => GoRouteData.$location(
    '/cart/items/${Uri.encodeComponent(_self.cartItemId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProductsRoute on GoRouteData {
  static ProductsRoute _fromState(GoRouterState state) => const ProductsRoute();

  @override
  String get location => GoRouteData.$location('/products');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProductRoute on GoRouteData {
  static ProductRoute _fromState(GoRouterState state) => ProductRoute(
    state.pathParameters['productId']!,
    $extra: state.extra as (OrderModel, OrderItemModel)?,
  );

  ProductRoute get _self => this as ProductRoute;

  @override
  String get location => GoRouteData.$location(
    '/products/${Uri.encodeComponent(_self.productId)}',
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
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
