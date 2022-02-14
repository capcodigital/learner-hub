import 'package:dartz/dartz.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/params/todo_params.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> createTodo(TodoParams todoParams);
  Future<Either<Failure, String>> deleteTodo(String todoId);
  Future<Either<Failure, Todo>> updateTodo(Todo todo);
}
