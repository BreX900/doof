import 'package:core/src/shared/data/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mek/mek.dart';

abstract final class CoreUtils {
  static const int tableSize = 10;

  static String translateError(Object error, {String? fallback}) {
    if (error is FirebaseAuthException) return error.message ?? '$error';
    if (error is Failure) return error.message;
    return fallback ?? '$error';
  }

  static void showErrorSnackBar(BuildContext context, Object error) {
    MekUtils.showErrorSnackBar(
      context: context,
      description: Text(translateError(error)),
    );
  }
}
