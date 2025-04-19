import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:mekart/mekart.dart';
import 'package:path_provider/path_provider.dart';

abstract final class Instances {
  static final BinConnection bins = BinConnection(_BinEngine());

  static FirebaseAuth get auth => FirebaseAuth.instance;

  static FirebaseFirestore get firestore {
    return FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      // databaseId: CoreEnv.mode == EnvMode.dev ? 'develop' : null,
    );
  }
}

class _BinEngine extends BinEngineBase {
  @override
  Future<String?> getDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
