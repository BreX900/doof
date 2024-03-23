enum SignInMethod { email, phoneNumber }

abstract class K {
  static const bool shouldVerifyEmail = false;
  static const Set<SignInMethod> signInMethods = {SignInMethod.email, SignInMethod.phoneNumber};
}
