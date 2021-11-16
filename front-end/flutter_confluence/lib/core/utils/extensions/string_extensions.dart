extension StringExtensions on String {
  bool containsIgnoreCase(String other) {
    return toUpperCase().contains(other.toUpperCase());
  }

  String getFirstCharacter({String defaultValue = ''}) {
    if (isNotEmpty) {
      return this[0];
    } else {
      return defaultValue;
    }
  }
}
