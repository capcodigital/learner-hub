import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/params/todo_params.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/create_todo.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/delete_todo.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/get_todos.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/update_todo.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(
      {required this.createTodoUsecase,
      required this.getTodosUsecase,
      required this.updateTodoUsecase,
      required this.deleteTodoUsecase})
      : super(TodoInitial()) {
    on<AddTodoEvent>(_addTodo);
    on<GetTodosEvent>(_getTodos);
    on<UpdateTodoEvent>(_updateTodo);
    on<DeleteTodoEvent>(_deleteTodo);
  }
  final CreateTodo createTodoUsecase;
  final GetTodos getTodosUsecase;
  final UpdateTodo updateTodoUsecase;
  final DeleteTodo deleteTodoUsecase;
  late List<Todo> todos;

  _addTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await createTodoUsecase(event.todo);

    emit(result.fold(
        (failure) => TodoLoadedError(message: 'Unable to add todo'), (todo) {
      todos.add(todo);
      return TodoLoadedSuccess(
          inProgressTodos: _sortTodosByCompletion(todos, false),
          completedTodos: _sortTodosByCompletion(todos, true));
    }));
  }

  _getTodos(GetTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await getTodosUsecase(NoParams());
    emit(result
        .fold((failure) => TodoLoadedError(message: 'Unable to get todos'),
            (loadedTodos) {
      todos = loadedTodos;
      return TodoLoadedSuccess(
          inProgressTodos: _sortTodosByCompletion(todos, false),
          completedTodos: _sortTodosByCompletion(todos, true));
    }));
  }

  _updateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await updateTodoUsecase(event.todo);
    emit(result
        .fold((failure) => TodoLoadedError(message: 'Unable to update todos'),
            (todo) {
      todos[todos.indexWhere((element) => element.id == event.todo.id)] =
          event.todo;
      return TodoLoadedSuccess(
          inProgressTodos: _sortTodosByCompletion(todos, false),
          completedTodos: _sortTodosByCompletion(todos, true));
    }));
  }

  _deleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await deleteTodoUsecase(event.todo.id);

    emit(result.fold(
        (failure) => TodoLoadedError(message: 'Unable to delete todos'), (_) {
      todos.removeWhere((element) => element == event.todo);
      return TodoLoadedSuccess(
          inProgressTodos: _sortTodosByCompletion(todos, false),
          completedTodos: _sortTodosByCompletion(todos, true));
    }));
  }

  List<Todo> _sortTodosByCompletion(List<Todo> todos, bool isCompleted) {
    return todos
        .where((element) => element.isCompleted == isCompleted)
        .toList();
  }
}
