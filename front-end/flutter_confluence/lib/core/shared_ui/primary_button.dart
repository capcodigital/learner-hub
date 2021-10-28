import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.text, this.isEnabled = true, this.onPressed});

  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Colours.ACCENT_COLOR, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)));

    final ButtonStyle disabledStyle = ElevatedButton.styleFrom(
        onSurface: Colours.ACCENT_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)));

    // ignore: sized_box_for_whitespace
    return Container(
        height: LayoutConstants.BTN_WIDGET_HEIGHT,
        width: double.infinity,
        child: ElevatedButton(
            style: isEnabled ? style : disabledStyle,
            onPressed: isEnabled ? onPressed : null,
            child: Text(text, style: Theme.of(context).textTheme.button)));
  }
}
