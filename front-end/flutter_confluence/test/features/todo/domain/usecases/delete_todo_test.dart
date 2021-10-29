import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/delete_todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

main() {
  late DeleteTodo usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = DeleteTodo(repository: mockTodoRepository);
  });

  const todo = Todo(
      id: '1',
      userId: '1',
      title: 'title',
      content: 'content',
      isCompleted: false);

  group('Retrieve from repository', () {
    test('Should return string from repository when successful', () async {
      // Arrange
      when(() => mockTodoRepository.deleteTodo(todo.id))
          .thenAnswer((invocation) async => const Right(''));
      // Act
      final result = await usecase(todo.id);
      // Assert
      expect(result, const Right(''));
      verify(() => mockTodoRepository.deleteTodo(todo.id));
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should return error from repository when failure', () async {
      // Arrange
      final error = ServerFailure(message: 'Error');
      when(() => mockTodoRepository.deleteTodo(todo.id))
          .thenAnswer((invocation) async => Left(error));
      // Act
      final result = await usecase(todo.id);
      // Assert
      expect(result, Left(error));
      verify(() => mockTodoRepository.deleteTodo(todo.id));
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
