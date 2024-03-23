// import 'package:core/core.dart';
// import 'package:flutter/widgets.dart';
// import 'package:mek_gasol/shared/apps/doof_app.dart';
// import 'package:mek_gasol/shared/navigation/routes/routes.dart';
//
// Widget buildAdminApp() {
//   final signedLocation = const AdminAreaRoute().location;
//
//   return DoofApp(
//     initialLocation: const SignInRoute().location,
//     routes: [$adminAreaRoute],
//     redirect: (state, isSigned) {
//       final isInSignOut = state.isLocationIn([
//         $signInRoute,
//         $signUpRoute,
//         $signEmailRoute,
//         $signUpDetailsRoute,
//         $signInPhoneNumberRoute,
//       ]);
//
//       if (isSigned) {
//         if (isInSignOut) return signedLocation;
//         return null;
//       } else {
//         if (isInSignOut) return null;
//         return const SignInRoute().location;
//       }
//     },
//   );
// }
