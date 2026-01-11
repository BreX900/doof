// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, cast_nullable_to_non_nullable

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

RouteBase get $signUpRoute =>
    GoRouteData.$route(path: '/sign-up', factory: $SignUpRoute._fromState);

mixin $SignUpRoute on GoRouteData {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  @override
  String get location => GoRouteData.$location('/sign-up');

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

RouteBase get $signEmailRoute => GoRouteData.$route(
  path: '/sign-email',
  factory: $SignEmailRoute._fromState,
);

mixin $SignEmailRoute on GoRouteData {
  static SignEmailRoute _fromState(GoRouterState state) =>
      const SignEmailRoute();

  @override
  String get location => GoRouteData.$location('/sign-email');

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

RouteBase get $signUpDetailsRoute => GoRouteData.$route(
  path: '/sign-details',
  factory: $SignUpDetailsRoute._fromState,
);

mixin $SignUpDetailsRoute on GoRouteData {
  static SignUpDetailsRoute _fromState(GoRouterState state) =>
      const SignUpDetailsRoute();

  @override
  String get location => GoRouteData.$location('/sign-details');

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
  path: '/sign-in-phone-number',
  factory: $SignInPhoneNumberRoute._fromState,
);

mixin $SignInPhoneNumberRoute on GoRouteData {
  static SignInPhoneNumberRoute _fromState(GoRouterState state) =>
      SignInPhoneNumberRoute(
        verificationId: state.uri.queryParameters['verification-id'],
      );

  SignInPhoneNumberRoute get _self => this as SignInPhoneNumberRoute;

  @override
  String get location => GoRouteData.$location(
    '/sign-in-phone-number',
    queryParams: {
      if (_self.verificationId != null) 'verification-id': _self.verificationId,
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
