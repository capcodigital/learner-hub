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