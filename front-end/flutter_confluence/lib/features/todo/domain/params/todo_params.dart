class TodoParams {
  TodoParams(
      {required this.title, required this.content, required this.isCompleted});

  final String title;
  final String content;
  final bool isCompleted;

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
