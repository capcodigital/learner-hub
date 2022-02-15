import 'package:dartz/dartz.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/core/usecases/usecase.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/repository/todo_repository.dart';

class UpdateTodo implements UseCase<Todo, Todo> {
  UpdateTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, Todo>> call(Todo todo) async {
    return repository.updateTodo(todo);
  }
}
