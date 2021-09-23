import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  ServerFailure({required this.message});
  final String message;
}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  AuthFailure(this.code);
  static const CODE_GENERIC_FAILURE = 'code_generic_failure';
  final String code;
}

class AuthExpirationFailure extends Failure {}
