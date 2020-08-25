import 'platform_web.dart' if (dart.library.io) 'platform_io.dart';

class GetPlatform {
  static bool get isWeb => GeneralPlatform.isWeb;
  static bool get isMacOS => GeneralPlatform.isMacOS;
  static bool get isWindows => GeneralPlatform.isWindows;
  static bool get isLinux => GeneralPlatform.isLinux;
  static bool get isAndroid => GeneralPlatform.isAndroid;
  static bool get isIOS => GeneralPlatform.isIOS;
  static bool get isFuchsia => GeneralPlatform.isFuchsia;
}
