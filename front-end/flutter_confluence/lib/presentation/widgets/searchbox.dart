import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onSearchTermChanged;
  final ValueChanged<String> onSearchSubmitted;

  const SearchBox({
    this.hintText = "Search...",
    this.onSearchTermChanged,
    required this.onSearchSubmitted});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final double widgetHeight = 50.0;

  final double iconHorizontalPadding = 20;
  final double iconSize = 30.0;

  final Color accentColour = Constants.JIRA_COLOR;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 10.0,
                offset: Offset(0, 10))],
          borderRadius: BorderRadius.circular(50.0)),
      child: TextField(
        onChanged: widget.onSearchTermChanged,
        onSubmitted: widget.onSearchSubmitted,
        decoration: InputDecoration(
            border: InputBorder.none,
            // These extra borders are required to work with web
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: widget.hintText,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, //TODO: No idea why the constant doesn't work here
                  right: 20.0),
              child: Icon(
                Icons.search,
                size: iconSize,
                color: Colors.black,
              ),
            )),
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
}
