import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onSearchTermChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final TextEditingController? controller;

  const SearchBox(
      {this.hintText = "Search...",
      this.onSearchTermChanged,
      this.controller,
      this.onSearchSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context, Dimen.scale_90_100),
      height: isPortrait(context)
          ? getHeight(context, Dimen.scale_56_1000)
          : getHeight(context, Dimen.scale_13_100),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45, blurRadius: 10.0, offset: Offset(0, 10))
          ],
          borderRadius: BorderRadius.circular(25.0)),
      child: LayoutBuilder(
          builder: (BuildContext ctx, BoxConstraints constraints) {
            return TextField(
              controller: controller,
              onChanged: (onSearchTermChanged),
              onSubmitted: (onSearchSubmitted),
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
                        left: constraints.maxHeight * Dimen.scale_20_100,
                        right: constraints.maxHeight * Dimen.scale_20_100),
                    child: Icon(
                      Icons.search,
                      size: constraints.maxHeight * Dimen.scale_70_100,
                      color: Colors.black45,
                    ),
                  )),
              style: TextStyle(
                fontSize: 18.0,
              ),
            );
          })
    );
  }
}
