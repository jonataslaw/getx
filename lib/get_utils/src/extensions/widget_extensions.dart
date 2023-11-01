import 'package:flutter/widgets.dart';

/// An extension on [Widget] providing utility methods for adding padding to a widget.
extension WidgetPaddingXExt on Widget {
  /// Adds padding to all sides of the widget.
  ///
  /// The [padding] parameter specifies the padding distance in logical pixels.
  /// This method returns a new widget with padding applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final paddedWidget = myWidget.paddingAll(16.0); // Adds 16.0 logical pixel padding to all sides.
  /// ```
  Widget paddingAll(final double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Adds symmetric padding to the widget.
  ///
  /// The [horizontal] parameter specifies the horizontal padding distance,
  /// and the [vertical] parameter specifies the vertical padding distance, both in logical pixels.
  /// This method returns a new widget with symmetric padding applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final paddedWidget = myWidget.paddingSymmetric(horizontal: 8.0, vertical: 16.0);
  /// // Adds 8.0 logical pixel horizontal padding and 16.0 logical pixel vertical padding.
  /// ```
  Widget paddingSymmetric({final double horizontal = 0.0, final double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this,);

  /// Adds padding to specific sides of the widget.
  ///
  /// The [left], [top], [right], and [bottom] parameters specify the padding distance
  /// for the respective sides in logical pixels. This method returns a new widget with
  /// padding applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final paddedWidget = myWidget.paddingOnly(left: 8.0, right: 8.0);
  /// // Adds 8.0 logical pixel padding to the left and right sides.
  /// ```
  Widget paddingOnly({
    final double left = 0.0,
    final double top = 0.0,
    final double right = 0.0,
    final double bottom = 0.0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  /// Adds zero padding to the widget.
  ///
  /// This method returns a new widget with zero padding applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final zeroPaddedWidget = myWidget.paddingZero; // Adds zero padding.
  /// ```
  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}

/// An extension on [Widget] providing utility methods for adding margin to a widget.
extension WidgetMarginX on Widget {
  /// Adds margin to all sides of the widget.
  ///
  /// The [margin] parameter specifies the margin distance in logical pixels.
  /// This method returns a new widget with margin applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final widgetWithMargin = myWidget.marginAll(16.0); // Adds 16.0 logical pixel margin to all sides.
  /// ```
  Widget marginAll(final double margin) => Container(
        margin: EdgeInsets.all(margin),
        child: this,
      );

  /// Adds symmetric margin to the widget.
  ///
  /// The [horizontal] parameter specifies the horizontal margin distance,
  /// and the [vertical] parameter specifies the vertical margin distance, both in logical pixels.
  /// This method returns a new widget with symmetric margin applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final widgetWithMargin = myWidget.marginSymmetric(horizontal: 8.0, vertical: 16.0);
  /// // Adds 8.0 logical pixel horizontal margin and 16.0 logical pixel vertical margin.
  /// ```
  Widget marginSymmetric({final double horizontal = 0.0, final double vertical = 0.0}) =>
      Container(
        margin:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  /// Adds margin to specific sides of the widget.
  ///
  /// The [left], [top], [right], and [bottom] parameters specify the margin distance
  /// for the respective sides in logical pixels. This method returns a new widget with
  /// margin applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final widgetWithMargin = myWidget.marginOnly(left: 8.0, right: 8.0);
  /// // Adds 8.0 logical pixel margin to the left and right sides.
  /// ```
  Widget marginOnly({
    final double left = 0.0,
    final double top = 0.0,
    final double right = 0.0,
    final double bottom = 0.0,
  }) =>
      Container(
        margin:
            EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
        child: this,
      );

  /// Adds zero margin to the widget.
  ///
  /// This method returns a new widget with zero margin applied to the provided widget.
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final widgetWithZeroMargin = myWidget.marginZero; // Adds zero margin.
  /// ```
  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);
}

/// An extension on [Widget] allowing you to insert widgets inside a [CustomScrollView].
extension WidgetSliverBoxXExt on Widget {
  /// Wraps the widget in a [SliverToBoxAdapter] to insert it inside a [CustomScrollView].
  ///
  /// This method is useful for inserting non-sliver widgets into a [CustomScrollView].
  ///
  /// Example usage:
  /// ```dart
  /// final myWidget = Text('Hello, World!');
  /// final sliverWidget = myWidget.sliverBox; // Converts the widget into a sliver for CustomScrollView.
  /// ```
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
