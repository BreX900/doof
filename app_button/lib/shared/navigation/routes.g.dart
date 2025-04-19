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

RouteBase get $qrCodeRoute => GoRouteData.$route(
      path: '/',
      factory: $QrCodeRouteExtension._fromState,
    );

extension $QrCodeRouteExtension on QrCodeRoute {
  static QrCodeRoute _fromState(GoRouterState state) => const QrCodeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $servicesRoute => GoRouteData.$route(
      path: '/services/:organizationId',
      factory: $ServicesRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'table-service',
          factory: $TicketCreateRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'table-service-requested',
          factory: $TicketCreatedRouteExtension._fromState,
        ),
      ],
    );

extension $ServicesRouteExtension on ServicesRoute {
  static ServicesRoute _fromState(GoRouterState state) => ServicesRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/services/${Uri.encodeComponent(organizationId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TicketCreateRouteExtension on TicketCreateRoute {
  static TicketCreateRoute _fromState(GoRouterState state) => TicketCreateRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/services/${Uri.encodeComponent(organizationId)}/table-service',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TicketCreatedRouteExtension on TicketCreatedRoute {
  static TicketCreatedRoute _fromState(GoRouterState state) =>
      TicketCreatedRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/services/${Uri.encodeComponent(organizationId)}/table-service-requested',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInPhoneNumberRoute => GoRouteData.$route(
      path: '/sign-in',
      factory: $SignInPhoneNumberRouteExtension._fromState,
    );

extension $SignInPhoneNumberRouteExtension on SignInPhoneNumberRoute {
  static SignInPhoneNumberRoute _fromState(GoRouterState state) =>
      SignInPhoneNumberRoute(
        organizationId: state.uri.queryParameters['organization-id'],
        verificationId: state.uri.queryParameters['verification-id'],
        shouldPop: _$convertMapValue(
                'should-pop', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  String get location => GoRouteData.$location(
        '/sign-in',
        queryParams: {
          if (organizationId != null) 'organization-id': organizationId,
          if (verificationId != null) 'verification-id': verificationId,
          if (shouldPop != false) 'should-pop': shouldPop.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
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
          factory: $ProductsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: ':productId',
              factory: $ProductRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/store/:organizationId/cart',
          factory: $CartRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'checkout',
              factory: $CartCheckoutRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: ':itemId',
              factory: $CartItemRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/store/:organizationId/orders',
          factory: $OrdersRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: ':orderId',
              factory: $OrderItemsRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $StoreRouteExtension on StoreRoute {
  static StoreRoute _fromState(GoRouterState state) => const StoreRoute();
}

extension $ProductsRouteExtension on ProductsRoute {
  static ProductsRoute _fromState(GoRouterState state) => ProductsRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/products',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductRouteExtension on ProductRoute {
  static ProductRoute _fromState(GoRouterState state) => ProductRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['productId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/products/${Uri.encodeComponent(productId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartRouteExtension on CartRoute {
  static CartRoute _fromState(GoRouterState state) => CartRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/cart',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartCheckoutRouteExtension on CartCheckoutRoute {
  static CartCheckoutRoute _fromState(GoRouterState state) => CartCheckoutRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/cart/checkout',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartItemRouteExtension on CartItemRoute {
  static CartItemRoute _fromState(GoRouterState state) => CartItemRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['itemId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/cart/${Uri.encodeComponent(itemId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrdersRouteExtension on OrdersRoute {
  static OrdersRoute _fromState(GoRouterState state) => OrdersRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/orders',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrderItemsRouteExtension on OrderItemsRoute {
  static OrderItemsRoute _fromState(GoRouterState state) => OrderItemsRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['orderId']!,
      );

  String get location => GoRouteData.$location(
        '/store/${Uri.encodeComponent(organizationId)}/orders/${Uri.encodeComponent(orderId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
