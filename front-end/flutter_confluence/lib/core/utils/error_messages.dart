// Place in utilities file called error_messages.dart
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const authErrorDialogBtnWidth = 132.0;

Widget showCustomDialog(
    BuildContext context,
    String message,
    Function? okCallback) {
  return Container(
    child: AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: authErrorDialogBtnWidth,
                  child: ElevatedButton(
                    child: new Text("OK"),
                    onPressed: () {
                      okCallback?.call();
                    },
                  ),
                ),
                Container(
                  width: authErrorDialogBtnWidth,
                  child: ElevatedButton(
                    child: new Text("Settings"),
                    onPressed: () {
                      AppSettings.openAppSettings();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
