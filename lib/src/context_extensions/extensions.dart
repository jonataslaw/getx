import 'package:flutter/widgets.dart';

extension MDQ on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;

  double get height => mediaQuerySize.height;

  double get width => mediaQuerySize.width;

  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.height -
            ((mediaQuerySize.height / 100) * reducedBy)) /
        dividedBy;
  }

  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) /
        dividedBy;
  }

  double ratio(
      {double dividedBy = 1,
      double reducedByW = 0.0,
      double reducedByH = 0.0}) {
    return heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }

  /// similar to MediaQuery.of(this).padding
  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  /// similar to MediaQuery.of(this).viewPadding
  EdgeInsets get mediaQueryViewPadding => MediaQuery.of(this).viewPadding;

  /// similar to MediaQuery.of(this).viewInsets;
  EdgeInsets get mediaQueryViewInsets => MediaQuery.of(this).viewInsets;

  /// similar to MediaQuery.of(this).orientation;
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// check if device is on landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// check if device is on portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// similar to MediaQuery.of(this).devicePixelRatio;
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// similar to MediaQuery.of(this).textScaleFactor;
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;

  /// get the shortestSide from screen
  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// True if width be larger than 800
  bool get showNavbar => (width > 800);

  /// True if the shortestSide is smaller than 600p
  bool get isPhone => (mediaQueryShortestSide < 600);

  /// True if the shortestSide is largest than 600p
  bool get isSmallTablet => (mediaQueryShortestSide >= 600);

  /// True if the shortestSide is largest than 720p
  bool get isLargeTablet => (mediaQueryShortestSide >= 720);

  /// True if the current device is Tablet
  bool get isTablet => isSmallTablet || isLargeTablet;
}
