part of 'todo_bloc.dart';

@immutable
abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoLoading extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoLoadedSuccess extends TodoState {
  TodoLoadedSuccess(
      {required this.inProgressTodos, required this.completedTodos});

  final List<MockTodo> inProgressTodos;
  final List<MockTodo> completedTodos;
  @override
  List<Object?> get props => [inProgressTodos, completedTodos];
}

class TodoLoadedError extends TodoState {
  @override
  List<Object?> get props => [];
}
