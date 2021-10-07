import '/core/error/failures.dart';

class WeakPasswordFailure extends AuthFailure {
  WeakPasswordFailure() : super('Password require at least 6 characters');
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

class NoCurrentUserLogged extends AuthFailure {
  NoCurrentUserLogged() : super('User is not logged or the token is expired or invalid');
}

class CreateUserError extends AuthFailure {
  CreateUserError() : super("It's not possible to create the user in the remote DB");
}

class AuthFailure extends Failure {
  AuthFailure(this.reason);

  static const CODE_GENERIC_FAILURE = 'code_generic_failure';
  final String reason;

  @override
  List<Object> get props => [reason];
}