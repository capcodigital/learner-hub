import 'package:flutter/widgets.dart';

/// A widget that automatically scrolls to the child widget
/// when it gains focus to be sure that the focused widget
/// is always visible in the screen
class AutoScrollWhenFocused extends StatelessWidget {
  const AutoScrollWhenFocused({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: child,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          Scrollable.ensureVisible(context);
        }
      },
    );
  }
}
