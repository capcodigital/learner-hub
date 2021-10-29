import 'package:flutter/material.dart';

import '/core/colours.dart';
import '/features/user_settings/presentation/widgets/auto_scroll_when_focused.dart';

/// A widget that wraps the logic and style of the input fields
/// of the user settings page
class EditableTextFormField extends StatelessWidget {
  const EditableTextFormField(
      {required this.controller,
      required this.readOnly,
      required this.textStyle,
      this.textAlign = TextAlign.start,
      this.maxLines = 1,
      this.keyboardType
      });

  final TextEditingController controller;
  final bool readOnly;
  final TextStyle? textStyle;

  final TextAlign textAlign;
  final int? maxLines;
  final TextInputType? keyboardType;

  get editingColour => Colours.ACCENT_COLOR;
  get readOnlyColour => Colors.grey;

  @override
  Widget build(BuildContext context) {
    return AutoScrollWhenFocused(
        child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: editingColour,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: readOnly ? readOnlyColour : editingColour),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: readOnly ? readOnlyColour : editingColour),
        ),
      ),
    ));
  }
}
