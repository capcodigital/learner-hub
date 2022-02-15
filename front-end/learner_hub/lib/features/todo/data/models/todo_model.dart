import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:learner_hub/features/todo/domain/entities/todo.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 2)
class TodoModel extends Equatable {
  const TodoModel(
      {required this.id,
      required this.content,
      required this.isCompleted,
      required this.title,
      required this.userId});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        id: json['id'],
        content: json['content'],
        isCompleted: json['isCompleted'],
        title: json['title'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final bool isCompleted;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String userId;

  @override
  List<Object?> get props => [id, title, userId, content, isCompleted];
}

extension TodoModelExtension on TodoModel {
  Todo get toTodo => Todo(
      id: id,
      userId: userId,
      title: title,
      content: content,
      isCompleted: isCompleted);
}
