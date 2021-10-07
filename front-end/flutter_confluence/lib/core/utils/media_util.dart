import 'package:flutter/material.dart';

abstract class MediaQueries {
  double get deviceHeight;
  double get deviceWidth;
  double get deviceHeightWithoutAppBar;
}

class MediaQueriesImpl implements MediaQueries {
  MediaQueriesImpl({required this.buildContext});

  final BuildContext buildContext;

  @override
  double get deviceHeight => _getFullDeviceHeight(buildContext)
      - _getStatusBarHeight(buildContext) - kToolbarHeight;

  @override
  double get deviceHeightWithoutAppBar =>
      _getFullDeviceHeight(buildContext) - _getStatusBarHeight(buildContext);

  @override
  double get deviceWidth => MediaQuery.of(buildContext).size.width;

  /// Takes in a size and applies a scale factor
  double applyWidgetSize(double originalSize, double scaleFactor) =>
      originalSize * scaleFactor;

  /// Returns a width scaled against screen width
  double applyWidth(BuildContext context, double scaleFactor) =>
      applyWidgetSize(deviceWidth, scaleFactor);

  /// Returns a height scaled against screen height
  double applyHeight(BuildContext context, double scale) {
    return deviceHeight * scale;
  }

  /// Returns full height of the screen
  double _getFullDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Returns height of status bar
  double _getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // move to device.dart
  bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // move to device.dart
  bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

}