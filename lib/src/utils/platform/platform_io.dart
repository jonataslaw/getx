import 'dart:io';

// ignore: avoid_classes_with_only_static_members
class GeneralPlatform {
  static bool get isWeb => false;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isWindows => Platform.isWindows;

  static bool get isLinux => Platform.isLinux;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get isFuchsia => Platform.isFuchsia;

  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
