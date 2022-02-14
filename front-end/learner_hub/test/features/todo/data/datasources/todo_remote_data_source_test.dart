import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:learner_hub/core/error/custom_exceptions.dart';
import 'package:learner_hub/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/params/todo_params.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

main() {
  late TodoRemoteDataSourceImpl remoteDataSourceImpl;
  late MockClient mockClient;
  late MockFirebaseAuth mockFirebaseAuth;

  final todoParams = TodoParams(
      title: 'Book the certification exam',
      content:
          'It needs to be booked from the oficial website and then claim the expenses back',
      isCompleted: true);

  final todoFromParams = Todo(
      id: '1',
      userId: '1',
      title: todoParams.title,
      content: todoParams.content,
      isCompleted: todoParams.isCompleted);

  setUp(() {
    mockClient = MockClient();
    mockFirebaseAuth = MockFirebaseAuth();
    remoteDataSourceImpl =
        TodoRemoteDataSourceImpl(auth: mockFirebaseAuth, client: mockClient);
    registerFallbackValue(Uri());
  });

  void _setUpMockHttpClientWithGet(String fixtureName, int statusCode) {
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async =>
            http.Response(fixture(fixtureName), statusCode));
  }

  void _setUpMockHttpClientWithPost(String fixtureName, int statusCode) {
    when(() =>
        mockClient.post(any(),
            headers: any(named: 'headers'),
            body: jsonEncode(todoParams))).thenAnswer(
        (invocation) async => http.Response(fixture(fixtureName), statusCode));
  }

  void _setUpMockHttpClientWithPut(String fixtureName, int statusCode) {
    when(() =>
        mockClient.put(any(),
            headers: any(named: 'headers'),
            body: jsonEncode(todoParams))).thenAnswer(
        (invocation) async => http.Response(fixture(fixtureName), statusCode));
  }

  void _setUpMockHttpClientWithDelete(String fixtureName, int statusCode) {
    when(() => mockClient.delete(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async =>
            http.Response(fixture(fixtureName), statusCode));
  }

  group('GET Todos', () {
    test('Should return a list of todos when a status code of 200 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithGet('todos/todos.json', 200);
      // Act
      final todos = await remoteDataSourceImpl.getTodos();
      // Assert
      expect(todos.length, equals(5));
    });
    test('Should throw a ServerException when a status code of 500 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithGet('todos/todos.json', 500);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.getTodos(),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 400 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithGet('server_response_error.json', 400);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.getTodos(),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 401 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithGet('server_response_error.json', 401);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.getTodos(),
          throwsA(predicate((f) => f is ServerException)));
    });
  });

  group('POST Todos', () {
    test(
        'Should return the newly created todo when a status code of 201 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPost('todos/create_todos.json', 201);
      // Act
      final todo = await remoteDataSourceImpl.addTodo(todoParams);
      // Assert
      expect(todo.title, todoParams.title);
      expect(todo.content, todoParams.content);
      expect(todo.isCompleted, todoParams.isCompleted);
    });
    test('Should throw a ServerException when a status code of 500 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPost('todos/todos.json', 500);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.addTodo(todoParams),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 400 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPost('server_response_error.json', 400);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.addTodo(todoParams),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 401 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPost('server_response_error.json', 401);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.addTodo(todoParams),
          throwsA(predicate((f) => f is ServerException)));
    });
  });

  group('PUT Todos', () {
    test('Should return the updated todo when a status code of 200 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPut('todos/create_todos.json', 200);
      // Act
      final todo = await remoteDataSourceImpl.updateTodo(todoFromParams);
      // Assert
      expect(todo.title, todoFromParams.title);
      expect(todo.content, todoFromParams.content);
      expect(todo.isCompleted, todoFromParams.isCompleted);
    });
    test('Should throw a ServerException when a status code of 500 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPut('todos/todos.json', 500);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.updateTodo(todoFromParams),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 400 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPut('server_response_error.json', 400);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.updateTodo(todoFromParams),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 401 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPut('server_response_error.json', 401);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.updateTodo(todoFromParams),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 404 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithPut('server_response_error.json', 404);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.updateTodo(todoFromParams),
          throwsA(predicate((f) => f is ServerException)));
    });
  });
  group('DELETE Todos', () {
    test(
        'Should return a message when the todo is delete and a status code of 200 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithDelete('todos/delete_todos.json', 200);
      // Act
      final resultString =
          await remoteDataSourceImpl.deleteTodo(todoFromParams.id);
      // Assert
      expect(resultString, 'Item deleted');
      expect(resultString, isA<String>());
    });
    test('Should throw a ServerException when a status code of 500 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithDelete('todos/todos.json', 500);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.deleteTodo(todoFromParams.id),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 400 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithDelete('server_response_error.json', 400);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.deleteTodo(todoFromParams.id),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 401 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithDelete('server_response_error.json', 401);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.deleteTodo(todoFromParams.id),
          throwsA(predicate((f) => f is ServerException)));
    });
    test('Should throw a ServerException when a status code of 404 is received',
        () async {
      // Arrange
      _setUpMockHttpClientWithDelete('server_response_error.json', 404);
      // Act
      // Assert
      expect(() async => remoteDataSourceImpl.deleteTodo(todoFromParams.id),
          throwsA(predicate((f) => f is ServerException)));
    });
  });
}
