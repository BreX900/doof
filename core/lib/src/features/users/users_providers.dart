import 'package:core/src/features/carts/repositories/cart_items_repository.dart';
import 'package:core/src/features/carts/repositories/carts_repository.dart';
import 'package:core/src/features/carts/repositories/local_cart_items_repository.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/features/users/failures.dart';
import 'package:core/src/features/users/repositories/users_repo.dart';
import 'package:core/src/shared/data/failure.dart';
import 'package:core/src/shared/instances.dart';
import 'package:core/src/utils/env.dart';
import 'package:core/src/utils/logger.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:rxdart/rxdart.dart';

enum SignStatus { none, unverified, partial, full }

class MissingCredentialsFailure extends Failure {
  @override
  String get message => 'Authentication required!';
}

abstract class UsersProviders {
  static final all = FutureProvider((ref) async {
    return await UsersRepository.instance.fetchAll();
  });

  static final current = FutureProvider<UserDto?>((ref) {
    final auth = ref.watch(currentAuth).requireValue;
    if (auth == null) return null;

    final user = ref.watch(single(auth.uid)).requireValue;
    if (user == null) return null;

    return user;
  });

  static final currentId = FutureProvider((ref) {
    final user = ref.watch(current).requireValue;
    return user?.id;
  });

  static final currentStatus = FutureProvider((ref) {
    final authUser = ref.watch(currentAuth).requireValue;
    if (authUser == null) return SignStatus.none;

    if (CoreEnv.shouldVerifyEmail && !authUser.emailVerified) return SignStatus.unverified;

    final user = ref.watch(single(authUser.uid)).requireValue;
    lg.info('DbUser: ${user?.id}');
    if (user == null) return SignStatus.partial;

    return SignStatus.full;
  });

  static final currentAuth = StreamProvider((ref) async* {
    if (Instances.auth.currentUser case final user?) yield user;
    yield* Instances.auth.userChanges();
  });

  static final BehaviorSubject<SignStatus> signStatusController = BehaviorSubject<SignStatus>(
    onListen: () async {
      await signStatusController.addStream(
        Instances.auth.userChanges().startWith(Instances.auth.currentUser).asyncExpand((
          authUser,
        ) async* {
          if (authUser == null) {
            yield SignStatus.none;
            return;
          }

          if (CoreEnv.shouldVerifyEmail && !authUser.emailVerified) {
            yield SignStatus.unverified;
            return;
          }

          yield* UsersRepository.instance.watch(authUser.uid).map((user) {
            lg.info('DbUser: ${user?.id}');
            if (user == null) return SignStatus.partial;

            return SignStatus.full;
          });
        }),
      );
    },
  );

  static final single = FutureProvider.family((ref, String userId) async {
    return await UsersRepository.instance.read(userId);
  });

  static Future<void> signIn(
    MutationRef ref, {
    required String email,
    required String password,
    required String? organizationId,
  }) async {
    final user = await UsersRepository.instance.signIn(email: email, password: password);

    await _moveCartItemsOnline(user, organizationId);
  }

  static Future<void> signUp(
    MutationRef ref, {
    required String email,
    required String password,
    required String passwordConfirmation,
    required String? organizationId,
  }) async {
    if (password != passwordConfirmation) throw PasswordsNotMatchFailure();

    final user = await UsersRepository.instance.signUp(email: email, password: password);
    await _moveCartItemsOnline(user, organizationId);
  }

  static Future<String> signInWithPhoneNumber(MutationRef ref, String phoneNumber) async {
    return await UsersRepository.instance.signInWithPhoneNumber(phoneNumber);
  }

  static Future<void> confirmPhoneNumberVerification(
    MutationRef ref,
    String verificationId, {
    required String code,
    required String? organizationId,
  }) async {
    final user = await UsersRepository.instance.confirmPhoneNumberVerification(
      verificationId,
      code: code,
    );
    await _moveCartItemsOnline(user, organizationId);
  }

  static Future<void> signOut() async {
    await Instances.auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(MutationRef ref, String email) async {
    await Instances.auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> _moveCartItemsOnline(AuthUserDto user, String? organizationId) async {
    if (organizationId == null) {
      await LocalCartItemsRepository.instance.clear();
      return;
    }

    final cartItems = await LocalCartItemsRepository.instance.fetchAll();
    if (cartItems.isEmpty) return;

    final personalCart = await CartsRepository.instance.fetchPersonal(
      organizationId,
      userId: user.id,
    );
    final String personalCartId;
    if (personalCart != null) {
      personalCartId = personalCart.id;
    } else {
      personalCartId = await CartsRepository.instance.create(
        organizationId,
        isPublic: false,
        title: null,
      );
    }

    await Future.wait(
      cartItems.map((item) async {
        return await CartItemsRepository.instance.upsert(
          personalCartId,
          item.change((c) => c..buyers = {...c.buyers, user.id}.toIList()),
        );
      }),
    );

    await LocalCartItemsRepository.instance.clear();
  }
}
