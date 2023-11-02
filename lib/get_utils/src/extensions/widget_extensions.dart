import 'package:flutter/widgets.dart';

/// add Padding Property to widget
extension WidgetPaddingX on Widget {
  Widget paddingAll(final double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({final double horizontal = 0.0, final double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget paddingOnly({
    final double left = 0.0,
    final double top = 0.0,
    final double right = 0.0,
    final double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}

/// Add margin property to widget
extension WidgetMarginX on Widget {
  Widget marginAll(final double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({final double horizontal = 0.0, final double vertical = 0.0}) =>
      Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget marginOnly({
    final double left = 0.0,
    final double top = 0.0,
    final double right = 0.0,
    final double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);
}

/// Allows you to insert widgets inside a CustomScrollView
extension WidgetSliverBoxX on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
