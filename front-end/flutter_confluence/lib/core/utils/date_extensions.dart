extension CustomizableDateTime on DateTime {
  static DateTime? customTime;
  static DateTime get current {
    if (customTime != null)
      return customTime!;
    else
      return DateTime.now();
  }
}