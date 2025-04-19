// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $signInRoute,
      $signUpRoute,
      $signEmailRoute,
      $signUpDetailsRoute,
      $signInPhoneNumberRoute,
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

RouteBase get $signUpRoute => GoRouteData.$route(
      path: '/sign-up',
      factory: $SignUpRouteExtension._fromState,
    );

extension $SignUpRouteExtension on SignUpRoute {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  String get location => GoRouteData.$location(
        '/sign-up',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signEmailRoute => GoRouteData.$route(
      path: '/sign-email',
      factory: $SignEmailRouteExtension._fromState,
    );

extension $SignEmailRouteExtension on SignEmailRoute {
  static SignEmailRoute _fromState(GoRouterState state) =>
      const SignEmailRoute();

  String get location => GoRouteData.$location(
        '/sign-email',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signUpDetailsRoute => GoRouteData.$route(
      path: '/sign-details',
      factory: $SignUpDetailsRouteExtension._fromState,
    );

extension $SignUpDetailsRouteExtension on SignUpDetailsRoute {
  static SignUpDetailsRoute _fromState(GoRouterState state) =>
      const SignUpDetailsRoute();

  String get location => GoRouteData.$location(
        '/sign-details',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInPhoneNumberRoute => GoRouteData.$route(
      path: '/sign-in-phone-number',
      factory: $SignInPhoneNumberRouteExtension._fromState,
    );

extension $SignInPhoneNumberRouteExtension on SignInPhoneNumberRoute {
  static SignInPhoneNumberRoute _fromState(GoRouterState state) =>
      SignInPhoneNumberRoute(
        verificationId: state.uri.queryParameters['verification-id'],
      );

  String get location => GoRouteData.$location(
        '/sign-in-phone-number',
        queryParams: {
          if (verificationId != null) 'verification-id': verificationId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
