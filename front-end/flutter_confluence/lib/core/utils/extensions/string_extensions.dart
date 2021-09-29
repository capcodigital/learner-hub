extension StringExtensions on String {
  bool containsIgnoreCase(String other) {
    return toUpperCase().contains(other.toUpperCase());
  }
}
