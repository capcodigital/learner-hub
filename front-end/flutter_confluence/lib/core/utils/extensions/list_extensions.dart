extension JsonExtensions on List<String> {
  String toJson() {
    return '[${map((e) => '"$e"').join(",")}]';
  }
}
