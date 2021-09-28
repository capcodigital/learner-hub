// ignore_for_file: avoid_classes_with_only_static_members

class EmailValidator {
  static bool isValid(String? input) {
    if (input == null || input.isEmpty) {
      return false;
    }

    // Note: Not the full regex according to the RFC, but good enough
    const pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);

    return regex.hasMatch(input);
  }
}
