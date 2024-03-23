import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firebase_auth_extensions.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/shared/instances.dart';
import 'package:core/src/utils/logger.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class UsersRepository {
  FirebaseAuth get _auth => Instances.auth;
  FirebaseFirestore get _firestore => Instances.firestore;

  static final UsersRepository instance = UsersRepository._();
  UsersRepository._();

  CollectionReference<UserDto> _ref() {
    return _firestore.collection('users').withJsonConverter(UserDto.fromJson);
  }

  Future<void> create({
    required String? displayName,
    required String? phoneNumber,
  }) async {
    final user = UserDto(
      id: '',
      phoneNumber: phoneNumber,
      displayName: displayName,
    );
    await _ref().doc(_auth.currentUser!.uid).set(user);
  }

  Future<AuthUserDto> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user!.toDto();
  }

  Future<AuthUserDto> signUp({required String email, required String password}) async {
    final credential = await Instances.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.toDto();
  }

  // TODO: Validate phoneNumber, must include a country code prefixed with plus sign ('+')
  Future<String> signInWithPhoneNumber(String phoneNumber) async {
    if (kIsWeb) {
      final result = await _auth.signInWithPhoneNumber(phoneNumber);
      return result.verificationId;
    } else {
      final sentToken = Completer<String>();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _auth.signInWithCredential,
        verificationFailed: (exception) {
          lg.severe(
            'FirebaseAuth.verifyPhoneNumber.verificationFailed',
            exception,
            StackTrace.current,
          );
        },
        codeSent: (verificationId, resendToken) {
          sentToken.complete(verificationId);
          lg.warning('FirebaseAuth.verifyPhoneNumber.codeSent(resendToken:$resendToken) ');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          lg.warning(
              'FirebaseAuth.verifyPhoneNumber.codeAutoRetrievalTimeout(verificationId:$verificationId)');
        },
      );
      return sentToken.future;
    }
  }

  Future<AuthUserDto> confirmPhoneNumberVerification(String id, {required String code}) async {
    final crendial = PhoneAuthProvider.credential(verificationId: id, smsCode: code);
    final credential = await _auth.signInWithCredential(crendial);
    return credential.user!.toDto();
  }

  Stream<UserDto?> watch(String uid) {
    return _ref()
        .doc(uid)
        .snapshots()
        .takeUntil(_auth.userLogged)
        .map((snapshot) => snapshot.data());
  }

  Stream<IList<UserDto>> watchAll() {
    return _ref().snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toIList();
    });
  }
}
