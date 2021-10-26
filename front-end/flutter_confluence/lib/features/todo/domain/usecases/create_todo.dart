import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';

class CreateTodo implements UseCase<Todo, TodoParams> {
  CreateTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, Todo>> call(TodoParams todoParams) {
    return repository.createTodo();
  }
}

class TodoParams {
  TodoParams(
      {required this.title, required this.content, required this.isCompleted});

  final String title;
  final String content;
  final bool isCompleted;
}
