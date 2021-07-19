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
  final width = MediaQuery.of(context).size.width;
  //print("getMediaWidth: " + width.toString());
  return width;
}

double getWidth(BuildContext context, double scale) {
  final width = getMediaWidth(context) * scale;
  //print("getWidth: " + width.toString());
  return width;
}

double getMediaHeight(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  //print("getMediaHeight: " + height.toString());
  return height;
}

double getMeaningfulHeight(BuildContext context) {
  final statusBarHeight = getStatusBarHeight(context);
  //print("statusBarHeight: " + statusBarHeight.toString());
  //print("appBarHeight: " + kToolbarHeight.toString());
  final height = getMediaHeight(context) - statusBarHeight - kToolbarHeight;
  //print("getMeaningfulHeight: " + height.toString());
  return height;
}

double getHeight(BuildContext context, double scale) {
  final height = getMeaningfulHeight(context) * scale;
  //print("getHeight: " + height.toString());
  return height;
}

double getMeaningfulHeightNoAppBar(BuildContext context) {
  final statusBarHeight = getStatusBarHeight(context);
  //print("statusBarHeight: " + statusBarHeight.toString());
  final height = getMediaHeight(context) - statusBarHeight;
  //print("getMeaningfulHeightNoAppBar: " + height.toString());
  return height;
}

double getHeightNoAppBar(BuildContext context, double scale) {
  final height = getMeaningfulHeightNoAppBar(context) * scale;
  //print("getHeightNoAppBar: " + height.toString());
  return height;
}
