import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';

class UpdateTodo implements UseCase<Todo, Todo> {
  UpdateTodo({required this.repository});
  final TodoRepository repository;

  @override
  Future<Either<Failure, Todo>> call(Todo todo) async {
    return repository.updateTodo();
  }
}
