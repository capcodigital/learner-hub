import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/create_todo.dart';

class UpdateTodo implements UseCase<Todo, TodoParams> {
  UpdateTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, Todo>> call(TodoParams todoParams) {
    return repository.updateTodo();
  }
}
