import 'package:flutter/widgets.dart';

import '../../../get.dart';

mixin GetResponsiveMixin on Widget {
  ResponsiveScreen get screen;
  bool get alwaysUseBuilder;

  @protected
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

  Widget? builder() => null;

  Widget? desktop() => null;

  Widget? phone() => null;

  Widget? tablet() => null;

  Widget? watch() => null;
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
class GetResponsiveView<T> extends GetView<T> with GetResponsiveMixin {
  @override
  final bool alwaysUseBuilder;

  @override
  final ResponsiveScreen screen;

  GetResponsiveView({
    this.alwaysUseBuilder = false,
    ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
    Key? key,
  })  : screen = ResponsiveScreen(settings),
        super(key: key);
}

class GetResponsiveWidget<T extends GetLifeCycleMixin> extends GetWidget<T>
    with GetResponsiveMixin {
  @override
  final bool alwaysUseBuilder;

  @override
  final ResponsiveScreen screen;

  GetResponsiveWidget({
    this.alwaysUseBuilder = false,
    ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
    Key? key,
  })  : screen = ResponsiveScreen(settings),
        super(key: key);
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
  bool get isDesktop => (screenType == ScreenType.desktop);

  /// Is [screenType] [ScreenType.Tablet]
  bool get isTablet => (screenType == ScreenType.tablet);

  /// Is [screenType] [ScreenType.Phone]
  bool get isPhone => (screenType == ScreenType.phone);

  /// Is [screenType] [ScreenType.Watch]
  bool get isWatch => (screenType == ScreenType.watch);

  double get _getdeviceWidth {
    if (_isPaltformDesktop) {
      return width;
    }
    return context.mediaQueryShortestSide;
  }

  ScreenType get screenType {
    final deviceWidth = _getdeviceWidth;
    if (deviceWidth >= settings.desktopChangePoint) return ScreenType.desktop;
    if (deviceWidth >= settings.tabletChangePoint) return ScreenType.tablet;
    if (deviceWidth < settings.watchChangePoint) return ScreenType.watch;
    return ScreenType.phone;
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
  watch,
  phone,
  tablet,
  desktop,
}
