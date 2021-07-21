import 'package:flutter/widgets.dart';

import '../../../get.dart';
import 'get_view.dart';

abstract class _GetResponsive<T> extends GetView<T> {
  final ResponsiveScreen screen;
  _GetResponsive(ResponsiveScreenSettings settings, {Key? key})
      : screen = ResponsiveScreen(settings),
        super(key: key);

  Widget? builder();
  Widget? phone();
  Widget? tablet();
  Widget? desktop();
  Widget? watch();
}

/// Extend this widget to build responsive view.
/// this widget contains the `screen` property that have all
/// information about the screen size and type.
/// You have two options to build it.
/// 1- with `builder` method you return the widget to build.
/// 2- with methods `desktop`, `tablet`,`phone`, `watch`. the specific
/// method will be built when the screen type matches the method
/// when the screen is [ScreenType.Tablet] the `tablet` method
/// will be exuded and so on.
/// Note if you use this method please set the
/// property `alwaysUseBuilder` to false
/// With `settings` property you can set the width limit for the screen types.
class GetResponsiveView<T> extends _GetResponsive<T> {
  final bool alwaysUseBuilder = true;
  GetResponsiveView(
      {alwaysUseBuilder,
      ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
      Key? key})
      : super(settings, key: key);
  @override
  Widget build(BuildContext context) {
    screen.context = context;
    Widget? widget;
    if (alwaysUseBuilder) {
      widget = builder();
      if (widget != null) return widget;
    }
    if (screen.isDesktop) {
      widget = desktop() ?? widget;
      if (widget != null) return widget;
    }
    if (screen.isTablet) {
      widget = tablet() ?? desktop();
      if (widget != null) return widget;
    }
    if (screen.isPhone) {
      widget = phone() ?? tablet() ?? desktop();
      if (widget != null) return widget;
    }
    return watch() ?? phone() ?? tablet() ?? desktop() ?? builder()!;
  }

  @override
  Widget? builder() => null;

  @override
  Widget? desktop() => null;

  @override
  Widget? phone() => null;

  @override
  Widget? tablet() => null;

  @override
  Widget? watch() => null;
}

class ResponsiveScreenSettings {
  /// When the width is greater als this value
  /// the display will be set as [ScreenType.Desktop]
  final double desktopChangePoint;

  /// When the width is greater als this value
  /// the display will be set as [ScreenType.Tablet]
  /// or when width greater als [watchChangePoint] and smaller als this value
  /// the display will be [ScreenType.Phone]
  final double tabletChangePoint;

  /// When the width is smaller als this value
  /// the display will be set as [ScreenType.Watch]
  /// or when width greater als this value and smaller als [tabletChangePoint]
  /// the display will be [ScreenType.Phone]
  final double watchChangePoint;

  const ResponsiveScreenSettings(
      {this.desktopChangePoint = 1200,
      this.tabletChangePoint = 600,
      this.watchChangePoint = 300});
}

class ResponsiveScreen {
  late BuildContext context;
  final ResponsiveScreenSettings settings;

  late bool _isPaltformDesktop;
  ResponsiveScreen(this.settings) {
    _isPaltformDesktop = GetPlatform.isDesktop;
  }

  double get height => context.height;
  double get width => context.width;

  /// Is [screenType] [ScreenType.Desktop]
  bool get isDesktop => (screenType == ScreenType.Desktop);

  /// Is [screenType] [ScreenType.Tablet]
  bool get isTablet => (screenType == ScreenType.Tablet);

  /// Is [screenType] [ScreenType.Phone]
  bool get isPhone => (screenType == ScreenType.Phone);

  /// Is [screenType] [ScreenType.Watch]
  bool get isWatch => (screenType == ScreenType.Watch);

  double get _getdeviceWidth {
    if (_isPaltformDesktop) {
      return width;
    }
    return context.mediaQueryShortestSide;
  }

  ScreenType get screenType {
    final deviceWidth = _getdeviceWidth;
    if (deviceWidth >= settings.desktopChangePoint) return ScreenType.Desktop;
    if (deviceWidth >= settings.tabletChangePoint) return ScreenType.Tablet;
    if (deviceWidth < settings.watchChangePoint) return ScreenType.Watch;
    return ScreenType.Phone;
  }

  /// Return widget according to screen type
  /// if the [screenType] is [ScreenType.Desktop] and
  /// `desktop` object is null the `tablet` object will be returned
  /// and if `tablet` object is null the `mobile` object will be returned
  /// and if `mobile` object is null the `watch` object will be returned
  ///  also when it is null.
  T? responsiveValue<T>({
    T? mobile,
    T? tablet,
    T? desktop,
    T? watch,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    if (isPhone && mobile != null) return mobile;
    return watch;
  }
}

enum ScreenType {
  Watch,
  Phone,
  Tablet,
  Desktop,
}
