// ignore_for_file: avoid_classes_with_only_static_members

class PasswordValidator {
  static bool isValid(String? input) {
    if (input == null || input.isEmpty) {
      return false;
    }

    // Note: We are using firebase, so we just check the length is at least 6 characters
    return input.length >= 6;
  }
}
