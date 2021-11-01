import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_confluence/features/todo/data/repository/todo_repository_impl.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/params/todo_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl repository;
  late MockTodoRemoteDataSource mockRemoteDataSource;
  late MockTodoLocalDataSource mockLocalDataSource;

  final cachedTodos = (json.decode(fixture('todos/cached_todos.json')) as List)
      .map((e) => TodoModel.fromJson(e))
      .toList();

  final result = json.decode(fixture('todos/todos.json'));
  final remoteTodos =
      // ignore: avoid_dynamic_calls
      (result['data'] as List).map((e) => TodoModel.fromJson(e)).toList();

  final todoParams =
      TodoParams(title: 'title', content: 'content', isCompleted: false);

  final todoFromParams = Todo(
      id: '1',
      userId: '1',
      title: todoParams.title,
      content: todoParams.content,
      isCompleted: todoParams.isCompleted);

  setUp(() {
    mockRemoteDataSource = MockTodoRemoteDataSource();
    mockLocalDataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource);
  });

  group('Get Todos', () {
    test(
        'Should return remote data when call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getTodos())
          .thenAnswer((invocation) async => remoteTodos);
      final todos = remoteTodos.map((e) => e.toTodo).toList();
      // Act
      final result = await repository.getTodos();
      final resultsFolded =
          result.fold((l) => ServerFailure(message: l.toString()), (r) => r);
      // Assert
      verify(() => mockRemoteDataSource.getTodos());
      expect(result.isRight(), true);
      expect(resultsFolded, todos);
      expect(resultsFolded, equals(todos));
    });
    test('Todos are saved to cache when retrieved from remote data source',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getTodos())
          .thenAnswer((invocation) async => remoteTodos);
      // Act
      await repository.getTodos();
      // Assert
      verify(() => mockRemoteDataSource.getTodos());
      verify(() => mockLocalDataSource.saveTodos(remoteTodos));
    });
    test(
        'Should return failure when remote data source and local data source fail',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getTodos())
          .thenThrow(ServerException(message: 'Error'));
      when(() => mockLocalDataSource.getTodos()).thenThrow(CacheException());
      // Act
      final result = await repository.getTodos();
      // Assert
      verify(() => mockRemoteDataSource.getTodos());
      expect(result, equals(const Left(ServerFailure(message: 'Error'))));
    });
    test('Todos are retrieved from cache when call to remote data source fails',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getTodos())
          .thenThrow(ServerException(message: 'Error'));
      when(() => mockLocalDataSource.getTodos())
          .thenAnswer((invocation) async => cachedTodos);
      final todos = cachedTodos.map((e) => e.toTodo).toList();
      // Act
      final result = await repository.getTodos();
      final resultsFolded =
          result.fold((l) => ServerFailure(message: l.toString()), (r) => r);
      // Assert
      verify(() => mockLocalDataSource.getTodos());
      expect(result.isRight(), true);
      expect(resultsFolded, todos);
      expect(resultsFolded, equals(todos));
    });
  });
  group('Create Todos', () {
    test(
        'Should return remote data when call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.addTodo(todoParams))
          .thenAnswer((invocation) async => remoteTodos.first);
      final todo = remoteTodos.map((e) => e.toTodo).toList().first;
      // Act
      final result = await repository.createTodo(todoParams);
      final resultsFolded =
          result.fold((l) => ServerFailure(message: l.toString()), (r) => r);
      // Assert
      verify(() => mockRemoteDataSource.addTodo(todoParams));
      expect(result.isRight(), true);
      expect(resultsFolded, todo);
      expect(resultsFolded, equals(todo));
    });
    test('Should return failure when remote data source fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.addTodo(todoParams))
          .thenThrow(ServerException(message: 'Error'));
      // Act
      final result = await repository.createTodo(todoParams);
      // Assert
      verify(() => mockRemoteDataSource.addTodo(todoParams));
      expect(result, equals(const Left(ServerFailure(message: 'Error'))));
    });
  });
  group('Update Todos', () {
    test(
        'Should return remote data when call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.updateTodo(todoFromParams))
          .thenAnswer((invocation) async => remoteTodos.first);
      final todo = remoteTodos.map((e) => e.toTodo).toList().first;
      // Act
      final result = await repository.updateTodo(todoFromParams);
      final resultsFolded =
          result.fold((l) => ServerFailure(message: l.toString()), (r) => r);
      // Assert
      verify(() => mockRemoteDataSource.updateTodo(todoFromParams));
      expect(result.isRight(), true);
      expect(resultsFolded, todo);
      expect(resultsFolded, equals(todo));
    });
    test('Should return failure when remote data source fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateTodo(todoFromParams))
          .thenThrow(ServerException(message: 'Error'));
      // Act
      final result = await repository.updateTodo(todoFromParams);
      // Assert
      verify(() => mockRemoteDataSource.updateTodo(todoFromParams));
      expect(result, equals(const Left(ServerFailure(message: 'Error'))));
    });
  });
  group('Delete Todos', () {
    test(
        'Should return remote data when call to remote data source is successful',
        () async {
      // Arrange
      const done = 'done';
      when(() => mockRemoteDataSource.deleteTodo(todoFromParams.id))
          .thenAnswer((invocation) async => done);
      // Act
      final result = await repository.deleteTodo(todoFromParams.id);
      final resultsFolded =
          result.fold((l) => ServerFailure(message: l.toString()), (r) => r);
      // Assert
      verify(() => mockRemoteDataSource.deleteTodo(todoFromParams.id));
      expect(result.isRight(), true);
      expect(resultsFolded, done);
      expect(resultsFolded, equals(done));
    });
    test('Should return failure when remote data source fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteTodo(todoFromParams.id))
          .thenThrow(ServerException(message: 'Error'));
      // Act
      final result = await repository.deleteTodo(todoFromParams.id);
      // Assert
      verify(() => mockRemoteDataSource.deleteTodo(todoFromParams.id));
      expect(result, equals(const Left(ServerFailure(message: 'Error'))));
    });
  });
}
