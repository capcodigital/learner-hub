import 'package:dartz/dartz.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/core/usecases/usecase.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/params/todo_params.dart';
import 'package:learner_hub/features/todo/domain/repository/todo_repository.dart';

class CreateTodo implements UseCase<Todo, TodoParams> {
  CreateTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, Todo>> call(TodoParams todoParams) async {
    return repository.createTodo(todoParams);
  }
}
