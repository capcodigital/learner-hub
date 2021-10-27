import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';

class DeleteTodo implements UseCase<void, String> {
  DeleteTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, void>> call(String todoId) async {
    return repository.deleteTodo(todoId);
  }
}
