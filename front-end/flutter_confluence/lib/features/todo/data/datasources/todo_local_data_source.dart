import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_hive_helper.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';

/// Our `TodoLocalDataSource` abstraction class.
///
/// This abstraction will be implemented in both `TodoLocalDataSourceImpl` and
/// `TodoHiveHelperImpl`, since they both require the same methods.

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  saveTodos(List<TodoModel> todos);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  TodoLocalDataSourceImpl({required this.hive});

  final TodoHiveHelperImpl hive;

  @override
  Future<List<TodoModel>> getTodos() async {
    final todos = await hive.getTodos();
    if (todos.isNotEmpty) {
      return todos;
    } else {
      throw CacheException();
    }
  }

  @override
  saveTodos(List<TodoModel> todos) async {
    return hive.saveTodos(todos);
  }
}
