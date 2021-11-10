import '/core/error/failures.dart';

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Password require at least 6 characters');
}

class AlreadyRegisteredFailure extends AuthFailure {
  const AlreadyRegisteredFailure() : super('The account already exists for that email.');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('No user found for that email.');
}

class InvalidPasswordFailure extends AuthFailure {
  const InvalidPasswordFailure() : super('Wrong password provided for that user.');
}

class NoCurrentUserLogged extends AuthFailure {
  const NoCurrentUserLogged() : super('User is not logged or the token is expired or invalid');
}

class CreateUserError extends AuthFailure {
  const CreateUserError() : super("It's not possible to create the user in the remote DB");
}

class AuthFailure extends Failure {
  const AuthFailure(message) : super(message: message);

  static const CODE_GENERIC_FAILURE = 'code_generic_failure';
}
