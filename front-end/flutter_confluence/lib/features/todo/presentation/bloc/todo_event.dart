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
  @override
  List<Object?> get props => [];
}

class UpdateTodoEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}
