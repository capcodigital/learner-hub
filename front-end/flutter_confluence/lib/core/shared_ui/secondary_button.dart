import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({required this.text, this.isEnabled = true, this.onPressed});

  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Colours.ALTERNATIVE_COLOR,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colours.PRIMARY_COLOR), borderRadius: BorderRadius.circular(150)));

    final ButtonStyle disabledStyle = ElevatedButton.styleFrom(
        primary: Colours.ALTERNATIVE_COLOR,
        onSurface: Colours.ALTERNATIVE_COLOR,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colours.PRIMARY_COLOR), borderRadius: BorderRadius.circular(150)));

    // ignore: sized_box_for_whitespace
    return Container(
        height: LayoutConstants.BTN_WIDGET_HEIGHT,
        width: double.infinity,
        child: ElevatedButton(
            style: isEnabled ? style : disabledStyle,
            onPressed: isEnabled ? onPressed : null,
            child: Text(text,
                style: Theme.of(context).textTheme.button?.copyWith(color: Colours.ALTERNATIVE_TEXT_COLOR))));
  }
}
