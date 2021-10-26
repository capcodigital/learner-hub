import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo();
  Future<TodoModel> updateTodo();
  Future<void> deleteTodo();
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  @override
  Future<TodoModel> addTodo() {
    // TODO: implement addTodo
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo() {
    // TODO: implement deleteTodo
    throw UnimplementedError();
  }

  @override
  Future<List<TodoModel>> getTodos() {
    // TODO: implement getTodos
    throw UnimplementedError();
  }

  @override
  Future<TodoModel> updateTodo() {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }
}
