import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExtensions on FirebaseAuth {
  Stream<void> get userLogged {
    assert(currentUser != null, 'User not logged!');
    return Stream.multi((controller) {
      final subscription = authStateChanges().listen((event) {
        if (event != null) return;
        controller.closeSync();
      });
      controller.onCancel = subscription.cancel;
    });
  }
}
