import 'package:dartz/dartz.dart';
import 'package:learner_hub/core/error/custom_exceptions.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:learner_hub/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:learner_hub/features/todo/data/models/todo_model.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/params/todo_params.dart';
import 'package:learner_hub/features/todo/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Todo>> createTodo(TodoParams todo) async {
    try {
      final result = await remoteDataSource.addTodo(todo);
      return Right(result.toTodo);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo(String todoId) async {
    try {
      final result = await remoteDataSource.deleteTodo(todoId);
      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todoModels = await remoteDataSource.getTodos();
      await localDataSource.saveTodos(todoModels);
      final todos = todoModels.map((e) => e.toTodo).toList();
      return Right(todos);
    } on ServerException catch (error) {
      try {
        final todoModels = await localDataSource.getTodos();
        final todos = todoModels.map((e) => e.toTodo).toList();
        return Right(todos);
      } on CacheException {
        return Left(ServerFailure(message: error.message));
      }
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final result = await remoteDataSource.updateTodo(todo);
      return Right(result.toTodo);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    }
  }
}
