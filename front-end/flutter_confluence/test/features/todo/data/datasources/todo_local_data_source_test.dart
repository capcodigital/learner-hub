import 'dart:convert';

import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_hive_helper.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTodoHiveHelperImpl extends Mock implements TodoHiveHelperImpl {}

void main() {
  late TodoLocalDataSourceImpl localDataSourceImpl;
  late MockTodoHiveHelperImpl hive;

  setUp(() {
    hive = MockTodoHiveHelperImpl();
    localDataSourceImpl = TodoLocalDataSourceImpl(hive: hive);
  });

  final expectedResult =
      (json.decode(fixture('todos/cached_todos.json')) as List)
          .map((e) => TodoModel.fromJson(e))
          .toList();

  group('Get todos from cache', () {
    test('Should return a list of todos from cache when there is data in cache',
        () async {
      // Arrange
      when(() => hive.getTodos())
          .thenAnswer((invocation) => Future.value(expectedResult));
      // Act
      final result = await localDataSourceImpl.getTodos();
      // Assert
      expect(result, expectedResult);
    });
    test('Should throw a CacheException when there is no data in cache',
        () async {
      // Arrange
      when(() => hive.getTodos())
          .thenAnswer((invocation) => Future.value(List.empty()));
      // Act
      // Assert
      expect(() async => localDataSourceImpl.getTodos(),
          throwsA(predicate((f) => f is CacheException)));
    });
  });
  group('Save todos', () {
    test('Should call Hive to cache data', () async {
      // Arrange
      when(() => hive.saveTodos(any()))
          .thenAnswer((invocation) => Future.value(true));
      // Act
      await localDataSourceImpl.saveTodos(expectedResult);
      // Assert
      verify(() => hive.saveTodos(expectedResult)).called(1);
      verifyNoMoreInteractions(hive);
    });
  });
}
