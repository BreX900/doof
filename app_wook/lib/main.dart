import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/apis/doof_migrations.dart';
import 'package:mek_gasol/apis/firebase/firebase_options.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/apps/user_app.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/widgets/guards/modules_app.dart';
import 'package:mek_gasol/shared/widgets/guards/modules_guard.dart';
import 'package:mek_gasol/shared/widgets/guards/version_guard.dart';

void main() async {
  // ignore: avoid_print
  print('0: This is a hester egg. Naa, I just have to try the CI. Env: ${Env.mode}.');

  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.reportRecords();
  Observers.attachAll();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MekUtils.errorTranslator = CoreUtils.translateError;

  if (Env.flavour == EnvFlavour.frontend) {
    _runApp(VersionGuard(
      child: buildUserApp(),
    ));
    // } else if (Env.flavour == EnvFlavour.backoffice) {
    //   _runApp(VersionGuard(
    //     child: buildAdminApp(),
    //   ));
  } else {
    _runApp(AppsGuard(
      values: EnvFlavour.values,
      pickerBuilder: (context, isLoading) {
        return AppsApp(
          isLoading: isLoading,
          values: EnvFlavour.values,
          bottom: Column(
            children: [
              if (kDebugMode)
                ListTile(
                  onTap: () => DoofDatabaseMigrations.instance.createCart(),
                  title: const Text('Create Kuama Cart'),
                ),
              if (kDebugMode)
                ListTile(
                  onTap: () => DoofDatabaseMigrations.instance.migrateMenu(),
                  title: const Text('Migrate Doof Menu'),
                ),
              if (kDebugMode)
                ListTile(
                  onTap: () => DoofDatabaseMigrations.instance.deleteCartsOrders(),
                  title: const Text('Delete Doof Carts/Orders'),
                ),
              Text('Env: ${Env.mode.name}'),
            ],
          ),
        );
      },
      builder: (context, value) {
        switch (value) {
          case EnvFlavour.frontend:
          case EnvFlavour.backoffice:
            return buildUserApp();
          // return buildAdminApp();
        }
      },
    ));
  }
}

void _runApp(Widget child) {
  runApp(MultiDispenser(
    dispensable: const [
      DataBuilders(
        errorBuilder: ErrorView.buildByData,
      ),
    ],
    child: child,
  ));
}
