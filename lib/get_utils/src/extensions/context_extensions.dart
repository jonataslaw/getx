import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  /// The same of [MediaQuery.sizeOf(context)]
  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  /// The same of [MediaQuery.of(context).size.height]
  /// Note: updates when you resize your screen (like on a browser or
  /// desktop window)
  double get height => mediaQuerySize.height;

  /// The same of [MediaQuery.of(context).size.width]
  /// Note: updates when you resize your screen (like on a browser or
  /// desktop window)
  double get width => mediaQuerySize.width;

  /// Gives you the power to get a portion of the height.
  /// Useful for responsive applications.
  ///
  /// [dividedBy] is for when you want to have a portion of the value you
  /// would get like for example: if you want a value that represents a third
  /// of the screen you can set it to 3, and you will get a third of the height
  ///
  /// [reducedBy] is a percentage value of how much of the height you want
  /// if you for example want 46% of the height, then you reduce it by 56%.
  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.height -
            ((mediaQuerySize.height / 100) * reducedBy)) /
        dividedBy;
  }

  /// Gives you the power to get a portion of the width.
  /// Useful for responsive applications.
  ///
  /// [dividedBy] is for when you want to have a portion of the value you
  /// would get like for example: if you want a value that represents a third
  /// of the screen you can set it to 3, and you will get a third of the width
  ///
  /// [reducedBy] is a percentage value of how much of the width you want
  /// if you for example want 46% of the width, then you reduce it by 56%.
  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) /
        dividedBy;
  }

  /// Divide the height proportionally by the given value
  double ratio({
    double dividedBy = 1,
    double reducedByW = 0.0,
    double reducedByH = 0.0,
  }) {
    return heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }

  /// similar to [MediaQuery.of(context).padding]
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode theme is enable
  bool get isDarkMode => (theme.brightness == Brightness.dark);

  /// give access to Theme.of(context).iconTheme.color
  Color? get iconColor => theme.iconTheme.color;

  /// similar to [MediaQuery.of(context).padding]
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// similar to [MediaQuery.paddingOf(context)]
  EdgeInsets get mediaQueryPadding => MediaQuery.paddingOf(this);

  /// similar to [MediaQuery.of(context).padding]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// similar to [MediaQuery.viewPaddingOf(context)]
  EdgeInsets get mediaQueryViewPadding => MediaQuery.viewPaddingOf(this);

  /// similar to [MediaQuery.viewInsetsOf(context)]
  EdgeInsets get mediaQueryViewInsets => MediaQuery.viewInsetsOf(this);

  /// similar to [MediaQuery.orientationOf(context)]
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// check if device is on landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// check if device is on portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// similar to [MediaQuery.devicePixelRatioOf(context)]
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// similar to [MediaQuery.textScaleFactorOf(context)]
  TextScaler get textScaleFactor => MediaQuery.textScalerOf(this);

  /// get the shortestSide from screen
  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// True if width be larger than 800
  bool get showNavbar => (width > 800);

  /// True if the width is smaller than 600p
  bool get isPhoneOrLess => width <= 600;

  /// True if the width is higher than 600p
  bool get isPhoneOrWider => width >= 600;

  /// True if the shortestSide is smaller than 600p
  bool get isPhone => (mediaQueryShortestSide < 600);

  /// True if the width is smaller than 600p
  bool get isSmallTabletOrLess => width <= 600;

  /// True if the width is higher than 600p
  bool get isSmallTabletOrWider => width >= 600;

  /// True if the shortestSide is largest than 600p
  bool get isSmallTablet => (mediaQueryShortestSide >= 600);

  /// True if the shortestSide is largest than 720p
  bool get isLargeTablet => (mediaQueryShortestSide >= 720);

  /// True if the width is smaller than 720p
  bool get isLargeTabletOrLess => width <= 720;

  /// True if the width is higher than 720p
  bool get isLargeTabletOrWider => width >= 720;

  /// True if the current device is Tablet
  bool get isTablet => isSmallTablet || isLargeTablet;

  /// True if the width is smaller than 1200p
  bool get isDesktopOrLess => width <= 1200;

  /// True if the width is higher than 1200p
  bool get isDesktopOrWider => width >= 1200;

  /// same as [isDesktopOrLess]
  bool get isDesktop => isDesktopOrLess;

  /// Returns a specific value according to the screen size
  /// if the device width is higher than or equal to 1200 return
  /// [desktop] value. if the device width is higher than  or equal to 600
  /// and less than 1200 return [tablet] value.
  /// if the device width is less than 300  return [watch] value.
  /// in other cases return [mobile] value.
  T responsiveValue<T>({
    T? watch,
    T? mobile,
    T? tablet,
    T? desktop,
  }) {
    assert(
        watch != null || mobile != null || tablet != null || desktop != null);

    var deviceWidth = mediaQuerySize.width;
    //big screen width can display smaller sizes
    final strictValues = [
      if (deviceWidth >= 1200) desktop, //desktop is allowed
      if (deviceWidth >= 600) tablet, //tablet is allowed
      if (deviceWidth >= 300) mobile, //mobile is allowed
      watch, //watch is allowed
    ].whereType<T>();
    final looseValues = [
      watch,
      mobile,
      tablet,
      desktop,
    ].whereType<T>();
    return strictValues.firstOrNull ?? looseValues.first;
  }
}

extension IterableExt<T> on Iterable<T> {
  /// The first element, or `null` if the iterable is empty.
  T? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
