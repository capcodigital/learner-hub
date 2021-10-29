import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/params/todo_params.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/create_todo.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/delete_todo.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/get_todos.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/update_todo.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTodo extends Mock implements CreateTodo {}

class MockGetTodos extends Mock implements GetTodos {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

void main() {
  late MockCreateTodo mockCreateTodo;
  late MockGetTodos mockGetTodos;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;
  late TodoBloc bloc;

  final todoParams = TodoParams(
      title: 'test title', content: 'test content', isCompleted: false);

  final todo = Todo(
      content: todoParams.content,
      id: '1',
      title: todoParams.title,
      isCompleted: todoParams.isCompleted,
      userId: '1');

  final List<Todo> todos = [
    const Todo(
        id: '1',
        content: 'content 1',
        isCompleted: false,
        title: 'title 1',
        userId: '1'),
    const Todo(
        id: '2',
        content: 'content 2',
        isCompleted: false,
        title: 'title 2',
        userId: '2'),
    const Todo(
        id: '3',
        content: 'content 3',
        isCompleted: true,
        title: 'title 3',
        userId: '3'),
    const Todo(
        id: '4',
        content: 'content 4',
        isCompleted: true,
        title: 'title 4',
        userId: '4')
  ];

  final todosOrderSuccess = [
    TodoLoading(),
    TodoLoadedSuccess(
        inProgressTodos:
            todos.where((element) => element.isCompleted == false).toList(),
        completedTodos:
            todos.where((element) => element.isCompleted == true).toList())
  ];
  final todosOrderFail = [TodoLoading(), TodoLoadedError(message: 'Error')];

  setUp(() {
    mockCreateTodo = MockCreateTodo();
    mockGetTodos = MockGetTodos();
    mockDeleteTodo = MockDeleteTodo();
    mockUpdateTodo = MockUpdateTodo();
    bloc = TodoBloc(
        createTodoUsecase: mockCreateTodo,
        getTodosUsecase: mockGetTodos,
        updateTodoUsecase: mockUpdateTodo,
        deleteTodoUsecase: mockDeleteTodo);
    bloc.todos = todos;
  });

  group('Get Todos Usecase', () {
    test('Initial bloc state should be TodosInitial', () {
      expect(bloc.state, equals(TodoInitial()));
    });
    test('bloc should call GetTodos usecase', () async {
      // Arrange
      when(() => mockGetTodos(NoParams()))
          .thenAnswer((invocation) async => Right(todos));
      // Act
      bloc.add(GetTodosEvent());
      await untilCalled(() => mockGetTodos(NoParams()));
      // Assert
      verify(() => mockGetTodos(NoParams()));
    });
    blocTest(
      'Should emit correct order of states when GetTodos called with success',
      build: () {
        when(() => mockGetTodos(NoParams()))
            .thenAnswer((invocation) async => Right(todos));
        return bloc;
      },
      act: (_) {
        return bloc.add(GetTodosEvent());
      },
      expect: () {
        return todosOrderSuccess;
      },
    );
    blocTest(
      'Should emit correct order of states when GetTodos called with failure',
      build: () {
        when(() => mockGetTodos(NoParams())).thenAnswer(
            (invocation) async => Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (_) => bloc.add(GetTodosEvent()),
      expect: () => todosOrderFail,
    );
  });
  group('Create Todo Usecase', () {
    test('bloc should call CreateTodo usecase', () async {
      // Arrange
      when(() => mockCreateTodo(todoParams))
          .thenAnswer((invocation) async => Right(todo));
      // Act
      bloc.add(AddTodoEvent(todo: todoParams));
      await untilCalled(() => mockCreateTodo(todoParams));
      // Assert
      verify(() => mockCreateTodo(todoParams));
    });
    blocTest(
      'Should emit correct order of states when CreateTodo called with success',
      build: () {
        when(() => mockCreateTodo(todoParams))
            .thenAnswer((invocation) async => Right(todo));
        return bloc;
      },
      act: (_) {
        bloc.add(AddTodoEvent(todo: todoParams));
      },
      expect: () {
        return [
          TodoLoading(),
          TodoLoadedSuccess(
              inProgressTodos: [
                const Todo(
                    id: '1',
                    content: 'content 1',
                    isCompleted: false,
                    title: 'title 1',
                    userId: '1'),
                const Todo(
                    id: '2',
                    content: 'content 2',
                    isCompleted: false,
                    title: 'title 2',
                    userId: '2'),
                todo
              ],
              completedTodos: todos
                  .where((element) => element.isCompleted == true)
                  .toList())
        ];
      },
    );
    blocTest(
      'Should emit correct order of states when CreateTodo called with failure',
      build: () {
        when(() => mockCreateTodo(todoParams)).thenAnswer(
            (invocation) async => Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (_) => bloc.add(AddTodoEvent(todo: todoParams)),
      expect: () => todosOrderFail,
    );
  });
  group('Update Todo Usecase', () {
    test('bloc should call UpdateTodo usecase', () async {
      // Arrange
      when(() => mockUpdateTodo(todo))
          .thenAnswer((invocation) async => Right(todo));
      // Act
      bloc.add(UpdateTodoEvent(todo: todo));
      await untilCalled(() => mockUpdateTodo(todo));
      // Assert
      verify(() => mockUpdateTodo(todo));
    });
    blocTest(
      'Should emit correct order of states when UpdateTodo called with success',
      build: () {
        when(() => mockUpdateTodo(todo))
            .thenAnswer((invocation) async => Right(todo));
        return bloc;
      },
      act: (_) {
        bloc.add(UpdateTodoEvent(todo: todo));
      },
      expect: () {
        return [
          TodoLoading(),
          TodoLoadedSuccess(
              inProgressTodos: [
                todo,
                const Todo(
                    id: '2',
                    content: 'content 2',
                    isCompleted: false,
                    title: 'title 2',
                    userId: '2'),
              ],
              completedTodos: todos
                  .where((element) => element.isCompleted == true)
                  .toList())
        ];
      },
    );
    blocTest(
      'Should emit correct order of states when UpdateTodo called with failure',
      build: () {
        when(() => mockUpdateTodo(todo)).thenAnswer(
            (invocation) async => Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (_) => bloc.add(UpdateTodoEvent(todo: todo)),
      expect: () => todosOrderFail,
    );
  });
  group('Delete Todos Usecase', () {
    test('bloc should call DeleteTodo usecase', () async {
      // Arrange
      when(() => mockDeleteTodo(todo.id))
          .thenAnswer((invocation) async => Right(todo));
      // Act
      bloc.add(DeleteTodoEvent(todo: todo));
      await untilCalled(() => mockDeleteTodo(todo.id));
      // Assert
      verify(() => mockDeleteTodo(todo.id));
    });
    blocTest(
      'Should emit correct order of states when DeleteTodo called with success',
      build: () {
        when(() => mockDeleteTodo(todo.id))
            .thenAnswer((invocation) async => Right(todo));
        return bloc;
      },
      act: (_) {
        return bloc.add(DeleteTodoEvent(todo: todo));
      },
      expect: () {
        return todosOrderSuccess;
      },
    );
    blocTest(
      'Should emit correct order of states when GetTodos called with failure',
      build: () {
        when(() => mockDeleteTodo(todo.id)).thenAnswer(
            (invocation) async => Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (_) => bloc.add(DeleteTodoEvent(todo: todo)),
      expect: () => todosOrderFail,
    );
  });
}
