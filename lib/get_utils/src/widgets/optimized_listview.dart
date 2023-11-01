import 'package:flutter/material.dart';

/// A customized [ListView] that optimizes rendering by using a [CustomScrollView].
///
/// The [OptimizedListView] is designed for efficient rendering of a list of items.
/// It uses a [CustomScrollView] under the hood and provides the ability to handle
/// an empty list gracefully.
///
/// To use this widget, provide a [list] of items and a [builder] function to build
/// each item's widget. You can customize various aspects of the list's behavior
/// such as scroll direction, controller, physics, and more.
///
/// Example usage:
/// ```dart
/// OptimizedListView<String>(
///   list: myStringList,
///   builder: (BuildContext context, ValueKey<String> key, String item) {
///     return ListTile(
///       key: key,
///       title: Text(item),
///     );
///   },
///   onEmpty: Text('No items to display'),
/// )
/// ```
class OptimizedListView<T> extends StatelessWidget {
  const OptimizedListView({
    required this.list,
    required this.builder,
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.onEmpty = const SizedBox.shrink(),
    this.shrinkWrap = false,
  }) : lenght = list.length;

  /// The list of items to be displayed in the optimized list.
  final List<T> list;

  /// The scroll direction of the list, either [Axis.vertical] (default) or [Axis.horizontal].
  final Axis scrollDirection;

  /// Whether the list should be displayed in reverse order.
  final bool reverse;

  /// An optional [ScrollController] to control the scrolling behavior.
  final ScrollController? controller;

  /// Whether the [CustomScrollView] should be the primary scroll view.
  final bool? primary;

  /// The physics that determine how the list should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the [CustomScrollView] should shrink-wrap its children.
  final bool shrinkWrap;

  /// The widget to display when the list is empty.
  final Widget onEmpty;

  /// The length of the list.
  final int lenght;

  /// A builder function to construct the widget for each item in the list.
  final Widget Function(BuildContext context, ValueKey<T> key, T item) builder;

  @override
  Widget build(final BuildContext context) {
    if (list.isEmpty) {
      return onEmpty;
    }

    return CustomScrollView(
      controller: controller,
      reverse: reverse,
      scrollDirection: scrollDirection,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (final BuildContext context, final int i) {
              final T item = list[i];
              final ValueKey<T> key = ValueKey<T>(item);
              return builder(context, key, item);
            },
            childCount: list.length,
            findChildIndexCallback: (final Key key) {
              return list.indexWhere((final m) => m == (key as ValueKey<T>).value);
            },
          ),
        ),
      ],
    );
  }
}
