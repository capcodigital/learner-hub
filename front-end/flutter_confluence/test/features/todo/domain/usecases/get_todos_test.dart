import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/get_todos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

main() {
  late GetTodos usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetTodos(repository: mockTodoRepository);
  });

  final todos = [
    const Todo(
        id: '1',
        userId: '1',
        title: 'title',
        content: 'content',
        isCompleted: false)
  ];

  group('Retrieve from repository', () {
    test('Should retrieve todo entities from repository when successful',
        () async {
      // Arrange
      when(() => mockTodoRepository.getTodos())
          .thenAnswer((invocation) async => Right(todos));
      // Act
      final result = await usecase(NoParams());
      // Assert
      expect(result, Right(todos));
      verify(() => mockTodoRepository.getTodos());
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should return error from repository when failure', () async {
      // Arrange
      const error = ServerFailure(message: 'Error');
      when(() => mockTodoRepository.getTodos())
          .thenAnswer((invocation) async => const Left(error));
      // Act
      final result = await usecase(NoParams());
      // Assert
      expect(result, const Left(error));
      verify(() => mockTodoRepository.getTodos());
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
