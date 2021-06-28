import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onSearchTermChanged;
  final ValueChanged<String> onSearchSubmitted;

  final double widgetHeight = 50.0;
  final double iconHorizontalPadding = 20.0;
  final double iconSize = 30.0;
  final Color accentColour = Constants.JIRA_COLOR;

  const SearchBox({
    this.hintText = "Search...",
    this.onSearchTermChanged,
    required this.onSearchSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
              color: Colors.black45,
              blurRadius: 10.0,
              offset: Offset(0, 10))],
          borderRadius: BorderRadius.circular(50.0)),
      child: TextField(
        onChanged: onSearchTermChanged,
        onSubmitted: onSearchSubmitted,
        decoration: InputDecoration(
            border: InputBorder.none,
            // These extra borders are required to work with web
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: hintText,
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: iconHorizontalPadding,
                  right: iconHorizontalPadding),
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
