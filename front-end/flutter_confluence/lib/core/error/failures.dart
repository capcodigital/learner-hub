import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message = ''});

  final String message;

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({required message}) : super(message: message);
}

class CacheFailure extends Failure {}

class NoInternetFailure extends Failure {}
