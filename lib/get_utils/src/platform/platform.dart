import 'dart:io' show Platform;

import 'platform_web.dart' if (dart.library.io) 'platform_io.dart';

class GetPlatform {
  GetPlatform._();

  /// * returns true if the app is running on web browser
  static bool get isWeb => GeneralPlatform.isWeb;

  /// * returns true if the app is running on MacOs
  static bool get isMacOS => GeneralPlatform.isMacOS;

  /// * returns true if the app is running Windows
  static bool get isWindows => GeneralPlatform.isWindows;

  /// * returns true if the app is running on Linux
  static bool get isLinux => GeneralPlatform.isLinux;

  /// * returns true if the app is running on Android
  static bool get isAndroid => GeneralPlatform.isAndroid;

  /// * returns true if the app is running on Ios
  static bool get isIOS => GeneralPlatform.isIOS;

  /// * returns true if the app is running on Fuchsia
  static bool get isFuchsia => GeneralPlatform.isFuchsia;

  /// * returns true if the app is running on Mobile
  /// * either Android or IOS or Fuchsia
  static bool get isMobile =>
      GetPlatform.isIOS || GetPlatform.isAndroid || GetPlatform.isFuchsia;

  /// * returns true if the app is running on Desktop
  /// * either Macos Or Windows Or Linux
  /// * wither Pc or Laptop
  static bool get isDesktop =>
      GetPlatform.isMacOS || GetPlatform.isWindows || GetPlatform.isLinux;

  /// * returns `True` if app is in testing
  static bool get isTesting => Platform.environment.containsKey('FLUTTER_TEST');
}
