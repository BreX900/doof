enum EnvMode { dev, prod }

enum EnvFlavour { frontend, backoffice }

abstract final class Env {
  static const String _mode = String.fromEnvironment('MODE');
  static const EnvMode mode = _mode == 'prod' ? EnvMode.prod : EnvMode.dev;

  static const String _flavour = String.fromEnvironment('FLAVOUR');
  static const EnvFlavour? flavour = _flavour == 'backoffice'
      ? EnvFlavour.backoffice
      : _flavour == 'frontend'
          ? EnvFlavour.frontend
          : null;

  static const String organizationId = 'wook';

  static const String cartId = 'wKHDzUogrbtMgRuS5V9G';

  static const String phoneNumber = String.fromEnvironment('PHONE_NUMBER');
}
