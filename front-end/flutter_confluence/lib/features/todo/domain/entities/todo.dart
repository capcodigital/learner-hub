import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Todo extends Equatable {
  Todo({required this.title, required this.content, required this.isCompleted});

  late String title;
  late String content;
  late bool isCompleted;

  @override
  List<Object?> get props => [title, content, isCompleted];
}
