// ignore_for_file: do_not_use_environment

enum EnvMode { dev, prod }

abstract class CoreEnv {
  static const String _mode = String.fromEnvironment('MODE');
  static const EnvMode mode = _mode == 'prod' ? EnvMode.prod : EnvMode.dev;

  static const bool shouldVerifyEmail =
      bool.fromEnvironment('SHOULD_VERIFY_EMAIL', defaultValue: true);
}
