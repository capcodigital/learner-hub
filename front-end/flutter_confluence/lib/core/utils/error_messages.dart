import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

const OK = 'OK';
const SETTINGS = 'Settings';

mixin CustomAlertDialog {
  showSettingsAlertDialog(BuildContext dialogContext, String message) {
    showPlatformDialog(
      context: dialogContext,
      builder: (_) => PlatformAlertDialog(
        content: PlatformText(message),
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

  showAlertDialog(BuildContext dialogContext, String message, { Function()? onDismiss}) {
    showPlatformDialog(
      context: dialogContext,
      builder: (_) => PlatformAlertDialog(
        content: PlatformText(message),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText(OK),
            onPressed: () {
              Navigator.pop(dialogContext);
              if (onDismiss != null) {
                onDismiss();
              }
            },
          )
        ],
      ),
    );
  }
}
