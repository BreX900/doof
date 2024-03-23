// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $signInRoute,
      $adminAreaRoute,
    ];

RouteBase get $signInRoute => GoRouteData.$route(
      path: '/sign-in',
      factory: $SignInRouteExtension._fromState,
    );

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  String get location => GoRouteData.$location(
        '/sign-in',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $adminAreaRoute => GoRouteData.$route(
      path: '/:organizationId',
      factory: $AdminAreaRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'ingredients',
          factory: $AdminIngredientCreateRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'ingredients/:ingredientId',
          factory: $AdminIngredientRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'orders/:orderId',
          factory: $AdminOrderRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'products',
          factory: $AdminProductCreateRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'products/:productId',
          factory: $AdminProductRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'categories',
          factory: $AdminCategoryCreateRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'categories/:categoryId',
          factory: $AdminCategoryRouteExtension._fromState,
        ),
      ],
    );

extension $AdminAreaRouteExtension on AdminAreaRoute {
  static AdminAreaRoute _fromState(GoRouterState state) => AdminAreaRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminIngredientCreateRouteExtension on AdminIngredientCreateRoute {
  static AdminIngredientCreateRoute _fromState(GoRouterState state) =>
      AdminIngredientCreateRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/ingredients',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminIngredientRouteExtension on AdminIngredientRoute {
  static AdminIngredientRoute _fromState(GoRouterState state) =>
      AdminIngredientRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['ingredientId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/ingredients/${Uri.encodeComponent(ingredientId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminOrderRouteExtension on AdminOrderRoute {
  static AdminOrderRoute _fromState(GoRouterState state) => AdminOrderRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['orderId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/orders/${Uri.encodeComponent(orderId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminProductCreateRouteExtension on AdminProductCreateRoute {
  static AdminProductCreateRoute _fromState(GoRouterState state) =>
      AdminProductCreateRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/products',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminProductRouteExtension on AdminProductRoute {
  static AdminProductRoute _fromState(GoRouterState state) => AdminProductRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['productId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/products/${Uri.encodeComponent(productId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminCategoryCreateRouteExtension on AdminCategoryCreateRoute {
  static AdminCategoryCreateRoute _fromState(GoRouterState state) =>
      AdminCategoryCreateRoute(
        state.pathParameters['organizationId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/categories',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AdminCategoryRouteExtension on AdminCategoryRoute {
  static AdminCategoryRoute _fromState(GoRouterState state) =>
      AdminCategoryRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['categoryId']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(organizationId)}/categories/${Uri.encodeComponent(categoryId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
