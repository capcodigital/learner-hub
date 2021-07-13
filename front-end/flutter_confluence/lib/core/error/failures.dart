import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
@override
List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});
}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  static const CODE_GENERIC_FAILURE = "code_generic_failure";
  final String code;
  AuthFailure(this.code);
}

class AuthExpirationFailure extends Failure {}