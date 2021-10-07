import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/device.dart';
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
    final MediaQueriesImpl mediaQueries =
        MediaQueriesImpl(buildContext: context);
    final DeviceImpl deviceImpl = DeviceImpl.getDefault();
    return Container(
        width: mediaQueries.applyWidth(context, LayoutConstants.MAX_SCALE),
        height: 50,
        // height: deviceImpl.isWeb
        //     ? mediaQueries.applyWidgetSize(
        //         LayoutConstants.SEARCHBOX_WIDTH, LayoutConstants.REGULAR_SCALE)
        //     : (mediaQueries.isPortrait(context)
        //         ? mediaQueries.applyWidgetSize(LayoutConstants.SEARCHBOX_WIDTH,
        //             LayoutConstants.LARGE_SCALE)
        //         : mediaQueries.applyWidgetSize(LayoutConstants.SEARCHBOX_WIDTH,
        //             LayoutConstants.SMALL_SCALE)),
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
                      left: constraints.maxHeight * LayoutConstants.SMALL_SCALE,
                      right:
                          constraints.maxHeight * LayoutConstants.SMALL_SCALE),
                  child: Icon(
                    Icons.search,
                    size: constraints.maxHeight * LayoutConstants.EXTRA_LARGE_SCALE,
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
