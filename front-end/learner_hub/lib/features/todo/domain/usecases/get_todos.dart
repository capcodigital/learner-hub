import 'package:dartz/dartz.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/core/usecases/usecase.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/repository/todo_repository.dart';

class GetTodos implements UseCase<List<Todo>, NoParams> {
  GetTodos({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams noParams) async {
    return repository.getTodos();
  }
}
