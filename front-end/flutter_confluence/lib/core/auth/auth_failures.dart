import 'package:flutter_confluence/core/error/failures.dart';

class WeakPasswordFailure extends AuthFailure {
  WeakPasswordFailure() : super('The password provided is too weak.');
}

class AlreadyRegisteredFailure extends AuthFailure {
  AlreadyRegisteredFailure() : super('The account already exists for that email.');
}

class InvalidEmailFailure extends AuthFailure {
  InvalidEmailFailure() : super('No user found for that email.');
}

class InvalidPasswordFailure extends AuthFailure {
  InvalidPasswordFailure() : super('Wrong password provided for that user.');
}

class AuthExpirationFailure extends AuthFailure {
  AuthExpirationFailure() : super('The token is expired or invalid');
}

class AuthFailure extends Failure {
  AuthFailure(this.reason);

  static const CODE_GENERIC_FAILURE = 'code_generic_failure';
  final String reason;
}
