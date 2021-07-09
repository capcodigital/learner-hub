import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

const OK = "OK";
const SETTINGS = "Settings";

showErrorDialog(BuildContext dialogContext, String message) {
  showPlatformDialog(
    context: dialogContext,
    builder: (_) => PlatformAlertDialog(
      content: Text(message),
      actions: <Widget>[
        PlatformDialogAction(
          child: PlatformText(OK),
          onPressed: () => Navigator.pop(dialogContext),
        ),
        PlatformDialogAction(
          child: PlatformText(SETTINGS),
          onPressed: () => AppSettings.openDeviceSettings(),
        ),
      ],
    ),
  );
}
