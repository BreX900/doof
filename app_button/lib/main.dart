import 'package:app_button/apis/firebase/firebase_options.dart';
import 'package:app_button/shared/app_theme.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mek/mek.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.reportRecords();
  Observers.attachAll();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fix many tasks scheduled at same time
  final container = ProviderContainer(
    observers: const [Observers.provider],
  )..dispose();

  runApp(App(
    container: container,
  ));
}

class App extends StatelessWidget {
  final ProviderContainer container;

  const App({
    super.key,
    required this.container,
  });

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container,
      child: CoreApp(
        initialLocation: const QrCodeRoute().location,
        routes: {null: $appRoutes},
        redirect: (context, status) => null,
        localizationsDelegates: const [AppFormats.delegate],
        theme: AppTheme.build(),
      ),
    );
  }
}
