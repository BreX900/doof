// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$signInRoute, $adminAreaRoute];

RouteBase get $signInRoute =>
    GoRouteData.$route(path: '/sign-in', factory: $SignInRoute._fromState);

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  @override
  String get location => GoRouteData.$location('/sign-in');

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

RouteBase get $adminAreaRoute => GoRouteData.$route(
  path: '/:organizationId',
  factory: $AdminAreaRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'ingredients',
      factory: $AdminIngredientCreateRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'ingredients/:ingredientId',
      factory: $AdminIngredientRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'orders/:orderId',
      factory: $AdminOrderRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'products',
      factory: $AdminProductCreateRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'products/:productId',
      factory: $AdminProductRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'categories',
      factory: $AdminCategoryCreateRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'categories/:categoryId',
      factory: $AdminCategoryRoute._fromState,
    ),
  ],
);

mixin $AdminAreaRoute on GoRouteData {
  static AdminAreaRoute _fromState(GoRouterState state) =>
      AdminAreaRoute(state.pathParameters['organizationId']!);

  AdminAreaRoute get _self => this as AdminAreaRoute;

  @override
  String get location =>
      GoRouteData.$location('/${Uri.encodeComponent(_self.organizationId)}');

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

mixin $AdminIngredientCreateRoute on GoRouteData {
  static AdminIngredientCreateRoute _fromState(GoRouterState state) =>
      AdminIngredientCreateRoute(state.pathParameters['organizationId']!);

  AdminIngredientCreateRoute get _self => this as AdminIngredientCreateRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/ingredients',
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

mixin $AdminIngredientRoute on GoRouteData {
  static AdminIngredientRoute _fromState(GoRouterState state) =>
      AdminIngredientRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['ingredientId']!,
      );

  AdminIngredientRoute get _self => this as AdminIngredientRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/ingredients/${Uri.encodeComponent(_self.ingredientId)}',
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

mixin $AdminOrderRoute on GoRouteData {
  static AdminOrderRoute _fromState(GoRouterState state) => AdminOrderRoute(
    state.pathParameters['organizationId']!,
    state.pathParameters['orderId']!,
  );

  AdminOrderRoute get _self => this as AdminOrderRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/orders/${Uri.encodeComponent(_self.orderId)}',
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

mixin $AdminProductCreateRoute on GoRouteData {
  static AdminProductCreateRoute _fromState(GoRouterState state) =>
      AdminProductCreateRoute(state.pathParameters['organizationId']!);

  AdminProductCreateRoute get _self => this as AdminProductCreateRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/products',
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

mixin $AdminProductRoute on GoRouteData {
  static AdminProductRoute _fromState(GoRouterState state) => AdminProductRoute(
    state.pathParameters['organizationId']!,
    state.pathParameters['productId']!,
  );

  AdminProductRoute get _self => this as AdminProductRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/products/${Uri.encodeComponent(_self.productId)}',
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

mixin $AdminCategoryCreateRoute on GoRouteData {
  static AdminCategoryCreateRoute _fromState(GoRouterState state) =>
      AdminCategoryCreateRoute(state.pathParameters['organizationId']!);

  AdminCategoryCreateRoute get _self => this as AdminCategoryCreateRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/categories',
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

mixin $AdminCategoryRoute on GoRouteData {
  static AdminCategoryRoute _fromState(GoRouterState state) =>
      AdminCategoryRoute(
        state.pathParameters['organizationId']!,
        state.pathParameters['categoryId']!,
      );

  AdminCategoryRoute get _self => this as AdminCategoryRoute;

  @override
  String get location => GoRouteData.$location(
    '/${Uri.encodeComponent(_self.organizationId)}/categories/${Uri.encodeComponent(_self.categoryId)}',
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
