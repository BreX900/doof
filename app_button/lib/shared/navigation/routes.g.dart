// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_literal_bool_comparisons, constant_identifier_names, unused_field

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $qrCodeRoute,
  $servicesRoute,
  $signInPhoneNumberRoute,
  $storeRoute,
];

RouteBase get $qrCodeRoute =>
    GoRouteData.$route(path: '/', factory: $QrCodeRoute._fromState);

mixin $QrCodeRoute on GoRouteData {
  static QrCodeRoute _fromState(GoRouterState state) => const QrCodeRoute();

  @override
  String get location => GoRouteData.$location('/');

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

RouteBase get $servicesRoute => GoRouteData.$route(
  path: '/services/:organizationId',
  factory: $ServicesRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'table-service',
      factory: $TicketCreateRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'table-service-requested',
      factory: $TicketCreatedRoute._fromState,
    ),
  ],
);

mixin $ServicesRoute on GoRouteData {
  static ServicesRoute _fromState(GoRouterState state) =>
      ServicesRoute(state.pathParameters['organizationId']!);

  ServicesRoute get _self => this as ServicesRoute;

  @override
  String get location => GoRouteData.$location(
    '/services/${Uri.encodeComponent(_self.organizationId)}',
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

mixin $TicketCreateRoute on GoRouteData {
  static TicketCreateRoute _fromState(GoRouterState state) =>
      TicketCreateRoute(state.pathParameters['organizationId']!);

  TicketCreateRoute get _self => this as TicketCreateRoute;

  @override
  String get location => GoRouteData.$location(
    '/services/${Uri.encodeComponent(_self.organizationId)}/table-service',
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

mixin $TicketCreatedRoute on GoRouteData {
  static TicketCreatedRoute _fromState(GoRouterState state) =>
      TicketCreatedRoute(state.pathParameters['organizationId']!);

  TicketCreatedRoute get _self => this as TicketCreatedRoute;

  @override
  String get location => GoRouteData.$location(
    '/services/${Uri.encodeComponent(_self.organizationId)}/table-service-requested',
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

RouteBase get $signInPhoneNumberRoute => GoRouteData.$route(
  path: '/sign-in',
  factory: $SignInPhoneNumberRoute._fromState,
);

mixin $SignInPhoneNumberRoute on GoRouteData {
  static SignInPhoneNumberRoute _fromState(GoRouterState state) =>
      SignInPhoneNumberRoute(
        organizationId: state.uri.queryParameters['organization-id'],
        verificationId: state.uri.queryParameters['verification-id'],
        shouldPop:
            _$convertMapValue(
              'should-pop',
              state.uri.queryParameters,
              _$boolConverter,
            ) ??
            false,
      );

  SignInPhoneNumberRoute get _self => this as SignInPhoneNumberRoute;

  @override
  String get location => GoRouteData.$location(
    '/sign-in',
    queryParams: {
      if (_self.organizationId != null) 'organization-id': _self.organizationId,
      if (_self.verificationId != null) 'verification-id': _self.verificationId,
      if (_self.shouldPop != false) 'should-pop': _self.shouldPop.toString(),
    },
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

RouteBase get $storeRoute => ShellRouteData.$route(
  factory: $StoreRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/store/:organizationId/products',
      factory: $ProductsRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: ':productId',
          factory: $ProductRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/store/:organizationId/cart',
      factory: $CartRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'checkout',
          factory: $CartCheckoutRoute._fromState,
        ),
        GoRouteData.$route(path: ':itemId', factory: $CartItemRoute._fromState),
      ],
    ),
    GoRouteData.$route(
      path: '/store/:organizationId/orders',
      factory: $OrdersRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: ':orderId',
          factory: $OrderItemsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $StoreRouteExtension on StoreRoute {
  static StoreRoute _fromState(GoRouterState state) => const StoreRoute();
}

mixin $ProductsRoute on GoRouteData {
  static ProductsRoute _fromState(GoRouterState state) =>
      ProductsRoute(state.pathParameters['organizationId']!);

  ProductsRoute get _self => this as ProductsRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/products',
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

mixin $ProductRoute on GoRouteData {
  static ProductRoute _fromState(GoRouterState state) => ProductRoute(
    state.pathParameters['organizationId']!,
    state.pathParameters['productId']!,
  );

  ProductRoute get _self => this as ProductRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/products/${Uri.encodeComponent(_self.productId)}',
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

mixin $CartRoute on GoRouteData {
  static CartRoute _fromState(GoRouterState state) =>
      CartRoute(state.pathParameters['organizationId']!);

  CartRoute get _self => this as CartRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/cart',
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

mixin $CartCheckoutRoute on GoRouteData {
  static CartCheckoutRoute _fromState(GoRouterState state) =>
      CartCheckoutRoute(state.pathParameters['organizationId']!);

  CartCheckoutRoute get _self => this as CartCheckoutRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/cart/checkout',
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

mixin $CartItemRoute on GoRouteData {
  static CartItemRoute _fromState(GoRouterState state) => CartItemRoute(
    state.pathParameters['organizationId']!,
    state.pathParameters['itemId']!,
  );

  CartItemRoute get _self => this as CartItemRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/cart/${Uri.encodeComponent(_self.itemId)}',
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
  static OrdersRoute _fromState(GoRouterState state) =>
      OrdersRoute(state.pathParameters['organizationId']!);

  OrdersRoute get _self => this as OrdersRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/orders',
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

mixin $OrderItemsRoute on GoRouteData {
  static OrderItemsRoute _fromState(GoRouterState state) => OrderItemsRoute(
    state.pathParameters['organizationId']!,
    state.pathParameters['orderId']!,
  );

  OrderItemsRoute get _self => this as OrderItemsRoute;

  @override
  String get location => GoRouteData.$location(
    '/store/${Uri.encodeComponent(_self.organizationId)}/orders/${Uri.encodeComponent(_self.orderId)}',
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
