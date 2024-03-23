import 'package:backoffice/apis/firebase/firebase_options.dart';
import 'package:backoffice/shared/admin_app.dart';
import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mek/mek.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.reportRecords();
  Observers.attachAll();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MekUtils.errorTranslator = CoreUtils.translateError;

  runApp(buildAdminApp());
}
