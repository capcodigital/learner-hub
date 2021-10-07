import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:platform/platform.dart';

abstract class Device {
  bool get isDesktop;
  bool get isMobile;
  bool get isWeb;
  bool get isWindows;
  bool get isLinux;
  bool get isMacOS;
  bool get isAndroid;
  bool get isFuchsia;
  bool get isIOS;
}

class DeviceImpl implements Device {
  DeviceImpl({required this.platform});
  final Platform platform;

  static DeviceImpl getDefault() { return DeviceImpl(platform: LocalPlatform()); }

  @override
  bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);

  @override
  bool get isMobile => !isWeb && (isAndroid || isIOS);

  @override
  bool get isWeb => kIsWeb;

  @override
  bool get isWindows => platform.isWindows;

  @override
  bool get isLinux => platform.isLinux;

  @override
  bool get isMacOS => platform.isMacOS;

  @override
  bool get isAndroid => platform.isAndroid;

  @override
  bool get isFuchsia => platform.isFuchsia;

  @override
  bool get isIOS => platform.isIOS;
}
