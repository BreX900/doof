abstract class Failure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class TargetNotFoundFailure extends Failure {
  final String identity;

  TargetNotFoundFailure(this.identity);

  @override
  String get message => 'Document $identity not exist.';
}

class AlreadyExistFailure extends Failure {
  final String identity;

  AlreadyExistFailure(this.identity);

  @override
  String get message => 'Document $identity already exist.';
}
