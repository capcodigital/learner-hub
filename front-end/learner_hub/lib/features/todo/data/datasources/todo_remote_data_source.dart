// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '/core/constants.dart';
import '/core/error/custom_exceptions.dart';
import '/features/todo/data/models/todo_model.dart';
import '/features/todo/domain/entities/todo.dart';
import '/features/todo/domain/params/todo_params.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo(TodoParams todo);
  Future<TodoModel> updateTodo(Todo todo);
  Future<String> deleteTodo(String todoId);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  TodoRemoteDataSourceImpl({required this.auth, required this.client});

  final FirebaseAuth auth;
  final http.Client client;
  @override
  Future<TodoModel> addTodo(TodoParams todoParams) async {
    try {
      const url = '${Constants.BASE_API_URL}/todos';

      final token = await auth.currentUser?.getIdToken();

      final body = jsonEncode(todoParams);

      final response = await client.post(Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: body);
      if (response.statusCode == 201) {
        final results = json.decode(response.body)['data'];
        final todo = TodoModel.fromJson(results);
        return todo;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        final message = json.decode(response.body)['error'];
        throw ServerException(message: message);
      } else {
        throw ServerException(message: 'Internal Server Error');
      }
    } on Exception catch (ex) {
      throw ServerException(message: ex.toString());
    }
  }

  @override
  Future<String> deleteTodo(String todoId) async {
    try {
      final url = '${Constants.BASE_API_URL}/todos/$todoId';

      final token = await auth.currentUser?.getIdToken();

      final response = await client.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['data'];
        return results['message'];
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        final message = json.decode(response.body)['error'];
        throw ServerException(message: message);
      } else {
        throw ServerException(message: 'Internal Server Error');
      }
    } on Exception catch (ex) {
      throw ServerException(message: ex.toString());
    }
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      const url = '${Constants.BASE_API_URL}/todos';

      final token = await auth.currentUser?.getIdToken();

      final response = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['data'];
        final todos =
            (results as List).map((e) => TodoModel.fromJson(e)).toList();
        return todos;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        final message = json.decode(response.body)['error'];
        throw ServerException(message: message);
      } else {
        throw ServerException(message: 'Internal Server Error');
      }
    } on Exception catch (ex) {
      throw ServerException(message: ex.toString());
    }
  }

  @override
  Future<TodoModel> updateTodo(Todo todo) async {
    try {
      final url = '${Constants.BASE_API_URL}/todos/${todo.id}';

      final token = await auth.currentUser?.getIdToken();

      final body = jsonEncode(TodoParams(
          title: todo.title,
          content: todo.content,
          isCompleted: todo.isCompleted));

      final response = await client.put(Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: body);
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['data'];
        final todo = TodoModel.fromJson(results);
        return todo;
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.statusCode == 404) {
        final message = json.decode(response.body)['error'];
        throw ServerException(message: message);
      } else {
        throw ServerException(message: 'Internal Server Error');
      }
    } on Exception catch (ex) {
      throw ServerException(message: ex.toString());
    }
  }
}
