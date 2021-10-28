import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Todo extends Equatable {
  const Todo(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content,
      required this.isCompleted});

  final String id;
  final String userId;
  final String title;
  final String content;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, userId, title, content, isCompleted];
}
