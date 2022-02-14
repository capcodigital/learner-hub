import 'package:dartz/dartz.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/core/usecases/usecase.dart';
import 'package:learner_hub/features/todo/domain/repository/todo_repository.dart';

class DeleteTodo implements UseCase<void, String> {
  DeleteTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, void>> call(String todoId) async {
    return repository.deleteTodo(todoId);
  }
}
