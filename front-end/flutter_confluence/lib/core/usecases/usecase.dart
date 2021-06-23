import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> Execute(Params params);
}
