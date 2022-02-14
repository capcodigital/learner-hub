import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/error/failures.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';
import 'package:learner_hub/features/todo/domain/repository/todo_repository.dart';
import 'package:learner_hub/features/todo/domain/usecases/update_todo.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

main() {
  late UpdateTodo usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = UpdateTodo(repository: mockTodoRepository);
  });

  const todo = Todo(
      id: '1',
      userId: '1',
      title: 'title',
      content: 'content',
      isCompleted: false);

  group('Retrieve from repository', () {
    test('Should return created todo entity from repository when successful',
        () async {
      // Arrange
      when(() => mockTodoRepository.updateTodo(todo))
          .thenAnswer((invocation) async => const Right(todo));
      // Act
      final result = await usecase(todo);
      // Assert
      expect(result, const Right(todo));
      verify(() => mockTodoRepository.updateTodo(todo));
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should return error from repository when failure', () async {
      // Arrange
      const error = ServerFailure(message: 'Error');
      when(() => mockTodoRepository.updateTodo(todo))
          .thenAnswer((invocation) async => const Left(error));
      // Act
      final result = await usecase(todo);
      // Assert
      expect(result, const Left(error));
      verify(() => mockTodoRepository.updateTodo(todo));
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
