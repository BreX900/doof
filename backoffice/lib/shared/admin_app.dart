import 'package:backoffice/shared/navigation/console_routes.dart';
import 'package:backoffice/shared/widgets/mek_widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

Widget buildAdminApp() {
  final signedLocation = const AdminAreaRoute(AdminAreaRoute.noOrganizationId).location;

  String? redirect(GoRouterState state, {required bool isSigned}) {
    final isInSignOut = state.isLocationIn([$signInRoute]);

    if (isSigned) {
      if (isInSignOut) return signedLocation;
      return null;
    } else {
      if (isInSignOut) return null;
      return const SignInRoute().location;
    }
  }

  final child = Builder(builder: (context) {
    final theme = MekTheme.build(context: context);

    return CoreApp(
      initialLocation: const SignInRoute().location,
      redirect: (state, status) {
        switch (status) {
          case SignStatus.none:
            return redirect(state, isSigned: false);
          case SignStatus.partial:
          case SignStatus.unverified:
          case SignStatus.full:
            return redirect(state, isSigned: true);
        }
      },
      routes: {
        null: [$signInRoute, $adminAreaRoute],
      },
      localizationsDelegates: const [AppFormats.delegate],
      theme: theme.copyWith(
        extensions: [
          ...theme.extensions.values,
          const DataBuilders(
            errorListener: CoreUtils.showErrorByData,
            errorBuilder: ErrorView.buildByData,
          )
        ],
      ),
    );
  });

  return child;
}
