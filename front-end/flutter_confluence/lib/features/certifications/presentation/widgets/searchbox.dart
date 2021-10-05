import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';

class SearchBox extends StatelessWidget {
  const SearchBox(
      {this.hintText = 'Search...',
      this.onSearchTermChanged,
      this.controller,
      this.onSearchSubmitted});
  final String hintText;
  final ValueChanged<String>? onSearchTermChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getWidth(context, LayoutConstants.scale_90_100),
        // Checking for web cause SearchBox height needs adjust
        height: kIsWeb
            ? getHeight(context, 0.07)
            : (isPortrait(context)
                ? getHeight(context, LayoutConstants.scale_56_1000)
                : getHeight(context, LayoutConstants.scale_13_100)),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10.0,
                  offset: Offset(0, 10))
            ],
            borderRadius: BorderRadius.circular(25.0)),
        child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
          return TextField(
            controller: controller,
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
                      left: constraints.maxHeight * LayoutConstants.scale_20_100,
                      right: constraints.maxHeight * LayoutConstants.scale_20_100),
                  child: Icon(
                    Icons.search,
                    size: constraints.maxHeight * LayoutConstants.scale_70_100,
                    color: Colors.black45,
                  ),
                )),
            style: const TextStyle(
              fontSize: 18.0,
            ),
          );
        }));
  }
}
