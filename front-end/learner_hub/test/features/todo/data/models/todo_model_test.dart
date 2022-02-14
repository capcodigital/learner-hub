import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/features/todo/data/models/todo_model.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const model = TodoModel(
      id: '5',
      content:
          'It needs to be booked from the oficial website and then claim the expenses back',
      isCompleted: true,
      title: 'Book the certification exam',
      userId: '5');

  group('Model matches JSON', () {
    test('Model extension is of Todo entity type', () {
      // Arrange
      // Act
      // Assert
      expect(model.toTodo, isA<Todo>());
    });
    test('Should deserialize model from JSON', () {
      // Arrange
      final jsonMap = json.decode(fixture('todos/todo_model.json'));
      // Act
      final todo = TodoModel.fromJson(jsonMap);
      // Assert
      expect(todo, equals(model));
      expect(todo.id, model.id);
      expect(todo.isCompleted, model.isCompleted);
      expect(todo.userId, model.userId);
      expect(todo.content, model.content);
      expect(todo.title, model.title);
    });
  });
}
