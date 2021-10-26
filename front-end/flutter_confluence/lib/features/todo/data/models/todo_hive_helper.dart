import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class TodoHiveHelper {
  Future<List<Todo>> getTodos();
  Future<void> saveTodos(List<TodoModel> todos);
}

class TodoHiveHelperImpl implements TodoHiveHelper {
  @override
  Future<List<Todo>> getTodos() async {
    final box = await Hive.openBox<TodoModel>('todos');
    final todos = box.values.toList().cast<TodoModel>();
    return todos;
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    final box = await Hive.openBox<TodoModel>('todos');
    box.clear();
    // ignore: prefer_foreach
    for (final todo in todos) {
      box.add(todo);
    }
  }
}
