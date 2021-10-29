import 'dart:convert';
import 'dart:io';

import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

List<CloudCertificationModel> getMockCompletedCertifications() {
  return (json.decode(fixture('certifications/completed.json')) as List)
      .map((e) => CloudCertificationModel.fromJson(e))
      .toList();
}

List<CloudCertificationModel> getMockInProgressCertifications() {
  return (json.decode(fixture('certifications/in_progress.json')) as List)
      .map((e) => CloudCertificationModel.fromJson(e))
      .toList();
}

List<TodoModel> getMockTodos() {
  return (json.decode(fixture('todos/todos.json')) as List)
      .map((e) => TodoModel.fromJson(e))
      .toList();
}
