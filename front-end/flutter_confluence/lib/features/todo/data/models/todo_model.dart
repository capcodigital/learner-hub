import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 2)
// ignore: must_be_immutable
class TodoModel extends Todo with HiveObjectMixin {
  TodoModel(
      {required this.id,
      required this.content,
      required this.isCompleted,
      required this.title,
      required this.userId})
      : super(
            id: id,
            content: content,
            isCompleted: isCompleted,
            title: title,
            userId: userId);

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

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String content;
  @override
  @HiveField(2)
  final bool isCompleted;
  @override
  @HiveField(3)
  final String title;
  @override
  @HiveField(4)
  final String userId;
}
