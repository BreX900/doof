import 'package:backoffice/features/categories/screens/admin_category_screen.dart'
    deferred as admin_category_screen;
import 'package:backoffice/features/ingredients/screens/admin_ingredient_screen.dart'
    deferred as admin_ingredient_screen;
import 'package:backoffice/features/orders/screens/admin_order_screen.dart'
    deferred as admin_order_screen;
import 'package:backoffice/features/products/screens/admin_product_screen.dart'
    deferred as admin_product_screen;
import 'package:backoffice/shared/navigation/areas/admin_area.dart' deferred as admin_area;
import 'package:core/core.dart' deferred as $sign_in_screen show SignInScreen;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

part 'console_routes.g.dart';

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: $sign_in_screen.loadLibrary,
      builder: (context) => $sign_in_screen.SignInScreen(),
    );
  }
}

// dart format off
@TypedGoRoute<AdminAreaRoute>(path: '/:organizationId', routes: [
  TypedGoRoute<AdminIngredientCreateRoute>(path: 'ingredients'),
  TypedGoRoute<AdminIngredientRoute>(path: 'ingredients/:ingredientId'),
  TypedGoRoute<AdminOrderRoute>(path: 'orders/:orderId'),
  TypedGoRoute<AdminProductCreateRoute>(path: 'products'),
  TypedGoRoute<AdminProductRoute>(path: 'products/:productId'),
  TypedGoRoute<AdminCategoryCreateRoute>(path: 'categories'),
  TypedGoRoute<AdminCategoryRoute>(path: 'categories/:categoryId'),
])
// dart format on
class AdminAreaRoute extends GoRouteData with $AdminAreaRoute {
  final String organizationId;

  static const String noOrganizationId = '#';

  const AdminAreaRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_area.loadLibrary,
      builder: (context) => admin_area.AdminArea(
        organizationId: organizationId == noOrganizationId ? null : organizationId,
      ),
    );
  }
}

class AdminOrderRoute extends GoRouteData with $AdminOrderRoute {
  final String organizationId;
  final String orderId;

  const AdminOrderRoute(this.organizationId, this.orderId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_order_screen.loadLibrary,
      builder: (context) =>
          admin_order_screen.AdminOrderScreen(organizationId: organizationId, orderId: orderId),
    );
  }
}

class AdminProductCreateRoute extends GoRouteData with $AdminProductCreateRoute {
  final String organizationId;

  const AdminProductCreateRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_product_screen.loadLibrary,
      builder: (context) => admin_product_screen.AdminProductScreen(organizationId: organizationId),
    );
  }
}

class AdminProductRoute extends GoRouteData with $AdminProductRoute {
  final String organizationId;
  final String productId;

  const AdminProductRoute(this.organizationId, this.productId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_product_screen.loadLibrary,
      builder: (context) => admin_product_screen.AdminProductScreen(
        organizationId: organizationId,
        productId: productId,
      ),
    );
  }
}

class AdminCategoryCreateRoute extends GoRouteData with $AdminCategoryCreateRoute {
  final String organizationId;

  const AdminCategoryCreateRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_category_screen.loadLibrary,
      builder: (context) =>
          admin_category_screen.AdminCategoryScreen(organizationId: organizationId),
    );
  }
}

class AdminCategoryRoute extends GoRouteData with $AdminCategoryRoute {
  final String organizationId;
  final String categoryId;

  const AdminCategoryRoute(this.organizationId, this.categoryId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_category_screen.loadLibrary,
      builder: (context) => admin_category_screen.AdminCategoryScreen(
        organizationId: organizationId,
        categoryId: categoryId,
      ),
    );
  }
}

class AdminIngredientCreateRoute extends GoRouteData with $AdminIngredientCreateRoute {
  final String organizationId;

  const AdminIngredientCreateRoute(this.organizationId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_ingredient_screen.loadLibrary,
      builder: (context) =>
          admin_ingredient_screen.AdminIngredientScreen(organizationId: organizationId),
    );
  }
}

class AdminIngredientRoute extends GoRouteData with $AdminIngredientRoute {
  final String organizationId;
  final String ingredientId;

  const AdminIngredientRoute(this.organizationId, this.ingredientId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: admin_ingredient_screen.loadLibrary,
      builder: (context) => admin_ingredient_screen.AdminIngredientScreen(
        organizationId: organizationId,
        ingredientId: ingredientId,
      ),
    );
  }
}
