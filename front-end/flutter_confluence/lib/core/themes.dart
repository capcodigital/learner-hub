// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

import 'colours.dart';
import 'constants.dart';

class Themes {

  static const  latoFontFamily = 'Lato';
  static const  futuraPTFontFamily = 'FuturaPT';

  static ThemeData appTheme = ThemeData(
      primaryColor: Colours.ACCENT_COLOR,
      textTheme: const TextTheme(
        headline1: TextStyle(
            color: Colours.PRIMARY_TEXT_COLOR, fontFamily: futuraPTFontFamily, fontWeight: FontWeight.w800, fontSize: 22.0),
        headline2: TextStyle(
            color: Colours.ALTERNATIVE_TEXT_COLOR, fontFamily: futuraPTFontFamily, fontWeight: FontWeight.w800, fontSize: 22.0),
        bodyText1: TextStyle(
            color: Colours.PRIMARY_TEXT_COLOR, fontFamily: latoFontFamily, fontWeight: FontWeight.w400, fontSize: 16.0),
        bodyText2: TextStyle(
            color: Colours.ALTERNATIVE_TEXT_COLOR, fontFamily: latoFontFamily, fontWeight: FontWeight.w400, fontSize: 16.0),
        button: TextStyle(
            color: Colours.PRIMARY_TEXT_COLOR, fontFamily: futuraPTFontFamily, fontWeight: FontWeight.w600, fontSize: 18.0),
        subtitle1: TextStyle(
            color: Colours.ALTERNATIVE_TEXT_COLOR, fontFamily: futuraPTFontFamily, fontWeight: FontWeight.w400, fontSize: 18.0),
        subtitle2: TextStyle(
            color: Constants.ACCENT_COLOR, fontFamily: futuraPTFontFamily, fontWeight: FontWeight.w600, fontSize: 18.0),
      ));
}
