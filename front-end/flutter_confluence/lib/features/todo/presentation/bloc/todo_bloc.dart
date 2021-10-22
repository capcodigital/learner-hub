import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<GetTodosEvent>(_getTodos);
  }

  Future<void> _getTodos(GetTodosEvent event, Emitter<TodoState> emit) async {
    final todos = [
      MockTodo(
          title: 'in progress test title',
          content: 'testing in progress content',
          isCompleted: false),
      MockTodo(
          title: 'done test title',
          content: 'testing completed content',
          isCompleted: true)
    ];
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

  final String title;
  final String content;
  final bool isCompleted;
}
