import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Void> {
  Future<Either<Failure, Type>> call();
}
