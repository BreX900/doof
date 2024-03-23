import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/navigation/routes/routes.dart';

/// Food app
class DoofApp extends StatelessWidget {
  final String initialLocation;
  final List<RouteBase> routes;
  // ignore: avoid_positional_boolean_parameters
  final String? Function(GoRouterState state, bool isSigned) redirect;

  const DoofApp({
    super.key,
    required this.initialLocation,
    required this.routes,
    required this.redirect,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    const colorPrimary = Color(0xFFFF0200);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: colorPrimary,
      brightness: brightness,
      background: brightness == Brightness.light ? null : Colors.black,
    );

    return CoreApp(
      initialLocation: initialLocation,
      redirect: (state, status) {
        switch (status) {
          case SignStatus.none:
            return redirect(state, false);
          case SignStatus.unverified:
            return const SignEmailRoute().location;
          case SignStatus.partial:
            return const SignUpDetailsRoute().location;
          case SignStatus.full:
            return redirect(state, true);
        }
      },
      routes: {
        null: [
          $signInRoute,
          $signUpRoute,
          $signInPhoneNumberRoute,
          ...routes,
        ],
        SignStatus.unverified: [$signEmailRoute],
        SignStatus.partial: [$signUpDetailsRoute],
      },
      localizationsDelegates: const [AppFormats.delegate],
      theme: MekTheme.build(
        colorScheme: colorScheme,
      ),
    );
  }
}
