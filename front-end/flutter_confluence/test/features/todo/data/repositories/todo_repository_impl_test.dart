import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_confluence/features/todo/data/repository/todo_repository_impl.dart';
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
      expect(result, equals(Left(ServerFailure(message: 'Error'))));
    });
  });
}
