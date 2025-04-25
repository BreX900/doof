import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:mek_gasol/shared/apps/doof_app.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/navigation/routes/routes.dart';

Widget buildUserApp() {
  final homeLocation = const ProductsRoute().location;

  return DoofApp(
    initialLocation: homeLocation,
    routes: [$signEmailRoute, $userAreaRoute],
    redirect: (state, isSigned) {
      final isInPublicRoute = state.isLocationIn([
        $signInRoute,
        $signEmailRoute,
        $signUpRoute,
        $signInPhoneNumberRoute,
      ]);

      if (isSigned) {
        if (isInPublicRoute) return homeLocation;
      } else {
        if (!isInPublicRoute) return const SignInRoute().location;
      }

      return null;
    },
  );
}
