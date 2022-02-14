import 'package:hive_flutter/hive_flutter.dart';
import 'package:learner_hub/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:learner_hub/features/todo/data/models/todo_model.dart';

class TodoHiveHelperImpl implements TodoLocalDataSource {
  @override
  Future<List<TodoModel>> getTodos() async {
    final box = await Hive.openBox<TodoModel>('todos');
    final todos = box.values.toList().cast<TodoModel>();
    return todos;
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    final box = await Hive.openBox<TodoModel>('todos');
    box.clear();
    for (final todo in todos) {
      box.add(todo);
    }
  }
}
