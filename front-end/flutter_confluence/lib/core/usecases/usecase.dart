import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Void> {
  Future<Either<Failure, Type>> call();
}

@override
class NoParams extends Equatable {
  List<Object> get props => [];
}

