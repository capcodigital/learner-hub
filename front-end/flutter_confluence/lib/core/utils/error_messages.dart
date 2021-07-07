import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const authErrorDialogBtnWidth = 132.0;

showAlertDialog(BuildContext dialogContext, String message) {
  AlertDialog alert = AlertDialog(
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
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                ),
              ),
              Container(
                width: authErrorDialogBtnWidth,
                child: ElevatedButton(
                  child: Text("Settings"),
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
  );

  // show the dialog
  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showCustomDialog(BuildContext context, String message, Function? okCallback) {
  ;
}
