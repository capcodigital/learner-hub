import 'package:flutter/material.dart';

Size getMediaSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double getMediaWidth(BuildContext context) {
  return getMediaSize(context).width;
}

double getMediaHeight(BuildContext context) {
  return getMediaSize(context).height;
}

double getScreenHeight(BuildContext context) {
  return getMediaHeight(context) -
      MediaQuery.of(context).padding.top -
      kToolbarHeight;
}

double getWidth(BuildContext context, double scale) {
  return getMediaSize(context).width * scale;
}

double getHeight(BuildContext context, double scale) {
  return getMediaSize(context).height * scale;
}
