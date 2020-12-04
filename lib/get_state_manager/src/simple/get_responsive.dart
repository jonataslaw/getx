import 'package:flutter/widgets.dart';

import '../../../get.dart';
import 'get_view.dart';

abstract class GetResponsive<T> extends GetView<T> {
  final ResponsiveScreen screen;
  GetResponsive(ResponsiveScreenSettings settings, {Key key})
      : screen = ResponsiveScreen(settings),
        super(key: key);

  Widget builder();
  Widget mobile();
  Widget tablet();
  Widget desktop();
  Widget watch();
}

class GetResponsiveView<T> extends GetResponsive<T> {
  final bool alwaysUseBuilder = true;
  GetResponsiveView(
      {alwaysUseBuilder,
      ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
      Key key})
      : super(settings, key: key);
  @override
  Widget build(BuildContext context) {
    screen.context = context;
    if (alwaysUseBuilder) {
      return builder();
    }
    Widget widget;
    if (screen.isDesktop) {
      widget = desktop();
      if (widget != null) return widget;
    }
    if (screen.isTablet) {
      widget = tablet();
      if (widget != null) return widget;
    }
    if (screen.isMobile) {
      widget = mobile();
      if (widget != null) return widget;
    }
    return watch();
  }

  @override
  Widget builder() => null;

  @override
  Widget desktop() => null;

  @override
  Widget mobile() => null;

  @override
  Widget tablet() => null;

  @override
  Widget watch() => null;
}

class ResponsiveScreenSettings {
  /// When the width is greater als this value
  /// the display will be set as [ScreenType.Desktop]
  final double desktopChangePoint;

  /// When the width is greater als this value
  /// the display will be set as [ScreenType.Tablet]
  /// or when width greater als [watchChangePoint] and smaller als this value
  /// the display will be [ScreenType.Mobile]
  final double tabletChangePoint;

  /// When the width is smaller als this value
  /// the display will be set as [ScreenType.Watch]
  /// or when width greater als this value and smaller als [tabletChangePoint]
  /// the display will be [ScreenType.Mobile]
  final double watchChangePoint;

  const ResponsiveScreenSettings(
      {this.desktopChangePoint = 1200,
      this.tabletChangePoint = 600,
      this.watchChangePoint = 300});
}

class ResponsiveScreen {
  BuildContext context;
  final ResponsiveScreenSettings settings;

  bool _isPaltformDesktop;
  ResponsiveScreen(this.settings) {
    _isPaltformDesktop = GetPlatform.isDesktop;
  }

  double get height => context.height;
  double get width => context.width;

  /// Is [screenType] [ScreenType.Desktop]
  bool get isDesktop => (screenType == ScreenType.Desktop);

  /// Is [screenType] [ScreenType.Tablet]
  bool get isTablet => (screenType == ScreenType.Tablet);

  /// Is [screenType] [ScreenType.Mobile]
  bool get isMobile => (screenType == ScreenType.Mobile);

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
    return ScreenType.Mobile;
  }

  /// Return widget according to screen type
  /// if the [screenType] is [ScreenType.Desktop] and
  /// `desktop` object is null the `tablet` object will be returned
  /// and if `tablet` object is null the `mobile` object will be returned
  /// and if `mobile` object is null the `watch` object will be returned
  ///  also when it is null.
  T responsiveValue<T>({
    T mobile,
    T tablet,
    T desktop,
    T watch,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    if (isMobile && mobile != null) return mobile;
    return watch;
  }
}

enum ScreenType {
  Watch,
  Mobile,
  Tablet,
  Desktop,
}
