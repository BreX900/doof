import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/utils/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

abstract final class Instances {
  static FirebaseAuth get auth => FirebaseAuth.instance;

  static FirebaseFirestore get firestore {
    return FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseURL: CoreEnv.mode == EnvMode.dev ? 'develop' : null,
    );
  }
}
