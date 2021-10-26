import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';

class DeleteTodo implements UseCase<String, String> {
  DeleteTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, String>> call(String todoId) {
    return repository.deleteTodo();
  }
}
