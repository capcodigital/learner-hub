import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';

class GetTodos implements UseCase<List<Todo>, NoParams> {
  GetTodos({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams noParams) {
    return repository.getTodos();
  }
}
