import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Void> {
  Future<Either<Failure, Type>> call();
}
