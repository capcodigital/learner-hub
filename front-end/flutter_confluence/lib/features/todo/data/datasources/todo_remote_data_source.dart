// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/params/todo_params.dart';
import 'package:http/http.dart' as http;

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
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['data'];
        final todo = TodoModel.fromJson(results);
        return todo;
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

      final response = await client.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['data'];
        final todo = TodoModel.fromJson(results);
        return todo;
      } else {
        throw ServerException(message: 'Internal Server Error');
      }
    } on Exception catch (ex) {
      throw ServerException(message: ex.toString());
    }
  }
}
