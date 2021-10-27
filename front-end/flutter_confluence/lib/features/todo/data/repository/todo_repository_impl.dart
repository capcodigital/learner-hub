import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/params/todo_params.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({required this.remoteDataSource});

  final TodoRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Todo>> createTodo(TodoParams todo) async {
    try {
      final result = await remoteDataSource.addTodo(todo);
      return Right(result);
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
      final todos = await remoteDataSource.getTodos();
      return Right(todos);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final result = await remoteDataSource.updateTodo(todo);
      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    }
  }
}
