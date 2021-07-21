import 'package:flutter/material.dart';

bool isLandscape(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

bool isPortrait(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}

double getStatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double getMediaWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getWidth(BuildContext context, double scale) {
  return getMediaWidth(context) * scale;
}

double getMediaHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getMeaningfulHeight(BuildContext context) {
  final statusBarHeight = getStatusBarHeight(context);
  return getMediaHeight(context) - statusBarHeight - kToolbarHeight;
}

double getHeight(BuildContext context, double scale) {
  return getMeaningfulHeight(context) * scale;
}

double getMeaningfulHeightNoAppBar(BuildContext context) {
  final statusBarHeight = getStatusBarHeight(context);
  return getMediaHeight(context) - statusBarHeight;
}

double getHeightNoAppBar(BuildContext context, double scale) {
  return getMeaningfulHeightNoAppBar(context) * scale;
}
