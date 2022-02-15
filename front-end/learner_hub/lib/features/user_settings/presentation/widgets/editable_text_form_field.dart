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
      this.keyboardType});

  // Required fields
  final TextEditingController controller;
  final bool readOnly;
  final TextStyle? textStyle;

  // Optional fields
  final TextAlign textAlign;
  final int? maxLines;
  final TextInputType? keyboardType;

  // Widget colours
  get _editingColour => Colours.ACCENT_COLOR;
  get _readOnlyColour => Colors.grey;
  get _borderColour => readOnly ? _readOnlyColour : _editingColour;

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
      cursorColor: _editingColour,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _borderColour),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _borderColour),
        ),
      ),
    ));
  }
}
