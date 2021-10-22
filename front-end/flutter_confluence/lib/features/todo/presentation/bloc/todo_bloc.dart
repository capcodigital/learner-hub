import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<GetTodosEvent>(_getTodos);
    on<UpdateTodoEvent>(_updateTodos);
  }

  final todos = [
    MockTodo(
        title: 'first in progress test title',
        content: 'first testing in progress content',
        isCompleted: false),
    MockTodo(
        title: 'first done test title',
        content: 'first testing completed content',
        isCompleted: true),
    MockTodo(
        title: 'second in progress test title',
        content: 'second testing in progress content',
        isCompleted: false),
    MockTodo(
        title: 'second done test title',
        content: 'second testing completed content',
        isCompleted: true)
  ];

  Future<void> _getTodos(GetTodosEvent event, Emitter<TodoState> emit) async {
    final inProgressTodos =
        todos.where((element) => element.isCompleted == false).toList();
    final completedTodos =
        todos.where((element) => element.isCompleted == true).toList();
    emit(TodoLoadedSuccess(
        inProgressTodos: inProgressTodos, completedTodos: completedTodos));
  }

  Future<void> _updateTodos(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    event.todo.isCompleted = true;
    final inProgressTodos =
        todos.where((element) => element.isCompleted == false).toList();
    final completedTodos =
        todos.where((element) => element.isCompleted == true).toList();
    emit(TodoLoadedSuccess(
        inProgressTodos: inProgressTodos, completedTodos: completedTodos));
  }
}

class MockTodo {
  MockTodo(
      {required this.title, required this.content, required this.isCompleted});

  String title;
  String content;
  bool isCompleted;
}
