import 'dart:async';

import 'package:core/core.dart' deferred as $sign_in_screen show SignInScreen;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/users/screens/sign_email_screen.dart'
    deferred as $sign_email_screen;
import 'package:mek_gasol/features/users/screens/sign_in_phone_number_screen.dart'
    deferred as sign_in_phone_number_screen;
import 'package:mek_gasol/features/users/screens/sign_up_details_screen.dart'
    deferred as $sign_up_details_screen;
import 'package:mek_gasol/features/users/screens/sign_up_screen.dart' deferred as $sign_up_screen;

part 'routes.g.dart';

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: $sign_in_screen.loadLibrary,
      builder: (context) => $sign_in_screen.SignInScreen(
        organizationId: Env.organizationId,
        onSignUp: () => unawaited(const SignUpRoute().push(context)),
      ),
    );
  }
}

@TypedGoRoute<SignUpRoute>(path: '/sign-up')
class SignUpRoute extends GoRouteData with $SignUpRoute {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: $sign_up_screen.loadLibrary,
      builder: (context) => $sign_up_screen.SignUpScreen(),
    );
  }
}

@TypedGoRoute<SignEmailRoute>(path: '/sign-email')
class SignEmailRoute extends GoRouteData with $SignEmailRoute {
  const SignEmailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: $sign_email_screen.loadLibrary,
      builder: (context) => $sign_email_screen.SignEmailScreen(),
    );
  }
}

@TypedGoRoute<SignUpDetailsRoute>(path: '/sign-details')
class SignUpDetailsRoute extends GoRouteData with $SignUpDetailsRoute {
  const SignUpDetailsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: $sign_up_details_screen.loadLibrary,
      builder: (context) => $sign_up_details_screen.SignUpDetailsScreen(),
    );
  }
}

@TypedGoRoute<SignInPhoneNumberRoute>(path: '/sign-in-phone-number')
class SignInPhoneNumberRoute extends GoRouteData with $SignInPhoneNumberRoute {
  final String? verificationId;

  const SignInPhoneNumberRoute({this.verificationId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeferredLibraryBuilder(
      loader: sign_in_phone_number_screen.loadLibrary,
      builder: (context) =>
          sign_in_phone_number_screen.SignInPhoneNumberScreen(verificationId: verificationId),
    );
  }
}
