// TODO: resolve platform/desktop by JS browser agent.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../../get_utils.dart';

html.Navigator _navigator = html.window.navigator;

// ignore: avoid_classes_with_only_static_members
class GeneralPlatform {
  static bool get isWeb => true;

  static bool get isMacOS =>
      _navigator.appVersion.contains('Mac OS') && !GeneralPlatform.isIOS;

  static bool get isWindows => _navigator.appVersion.contains('Win');

  static bool get isLinux =>
      (_navigator.appVersion.contains('Linux') ||
          _navigator.appVersion.contains('x11')) &&
      !isAndroid;

  // @check https://developer.chrome.com/multidevice/user-agent
  static bool get isAndroid => _navigator.appVersion.contains('Android ');

  static bool get isIOS {
    // maxTouchPoints is needed to separate iPad iOS13 vs new MacOS
    return GetUtils.hasMatch(_navigator.platform, r'/iPad|iPhone|iPod/') ||
        (_navigator.platform == 'MacIntel' && _navigator.maxTouchPoints > 1);
  }

  static bool get isFuchsia => false;

  static bool get isDesktop => isMacOS || isWindows || isLinux;
}
