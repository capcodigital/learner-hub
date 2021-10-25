part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {}

class GetTodosEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class AddTodoEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class DeleteTodoEvent extends TodoEvent {
  DeleteTodoEvent({required this.todo});

  final MockTodo todo;
  @override
  List<Object?> get props => [todo];
}

class UpdateTodoEvent extends TodoEvent {
  UpdateTodoEvent({required this.todo});

  final MockTodo todo;
  @override
  List<Object?> get props => [todo];
}
