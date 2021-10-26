import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddTodoEvent>(_addTodo);
    on<GetTodosEvent>(_getTodos);
    on<UpdateTodoEvent>(_updateTodo);
    on<DeleteTodoEvent>(_deleteTodo);
  }

  final todos = [
    Todo(
        title: 'first in progress test title',
        content: 'first testing in progress content',
        isCompleted: false),
    Todo(
        title: 'first done test title',
        content: 'first testing completed content',
        isCompleted: true),
    Todo(
        title: 'second in progress test title',
        content: 'second testing in progress content',
        isCompleted: false),
    Todo(
        title: 'third in progress test title',
        content: 'third testing in progress content',
        isCompleted: false),
    Todo(
        title: 'fourth in progress test title',
        content: 'fourth testing in progress content',
        isCompleted: false),
    Todo(
        title: 'fifth in progress test title',
        content: 'fifth testing in progress content',
        isCompleted: false),
    Todo(
        title: 'sixth in progress test title',
        content: 'sixth testing in progress content',
        isCompleted: false),
    Todo(
        title: 'seventh in progress test title',
        content: 'seventh testing in progress content',
        isCompleted: false),
    Todo(
        title: 'eighth in progress test title',
        content: 'eighth testing in progress content',
        isCompleted: false),
    Todo(
        title: 'second done test title',
        content: 'second testing completed content',
        isCompleted: true)
  ];

  Future<void> _addTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    todos.add(event.todo);
    final inProgressTodos =
        todos.where((element) => element.isCompleted == false).toList();
    final completedTodos =
        todos.where((element) => element.isCompleted == true).toList();
    emit(TodoLoadedSuccess(
        inProgressTodos: inProgressTodos, completedTodos: completedTodos));
  }

  Future<void> _getTodos(GetTodosEvent event, Emitter<TodoState> emit) async {
    final inProgressTodos =
        todos.where((element) => element.isCompleted == false).toList();
    final completedTodos =
        todos.where((element) => element.isCompleted == true).toList();
    emit(TodoLoadedSuccess(
        inProgressTodos: inProgressTodos, completedTodos: completedTodos));
  }

  Future<void> _updateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    final inProgressTodos =
        todos.where((element) => element.isCompleted == false).toList();
    final completedTodos =
        todos.where((element) => element.isCompleted == true).toList();
    emit(TodoLoadedSuccess(
        inProgressTodos: inProgressTodos, completedTodos: completedTodos));
  }

  Future<void> _deleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    todos.removeWhere((element) => element == event.todo);
    final inProgressTodos =
        todos.where((element) => element.isCompleted == false).toList();
    final completedTodos =
        todos.where((element) => element.isCompleted == true).toList();
    emit(TodoLoadedSuccess(
        inProgressTodos: inProgressTodos, completedTodos: completedTodos));
  }
}
