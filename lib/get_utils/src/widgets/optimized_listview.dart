import 'package:flutter/material.dart';

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
  }) : length = list.length;
  final List<T> list;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget onEmpty;
  final int length;
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
              return list
                  .indexWhere((final T m) => m == (key as ValueKey<T>).value);
            },
          ),
        ),
      ],
    );
  }
}
