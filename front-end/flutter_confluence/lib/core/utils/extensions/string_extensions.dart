extension StringExtensions on String {
  bool containsIgnoreCase(String other) {
    return this.toUpperCase().contains(other.toUpperCase());
  }
}
