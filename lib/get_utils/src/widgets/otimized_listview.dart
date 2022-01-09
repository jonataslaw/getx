import 'package:flutter/material.dart';

class OtimizedListView<T> extends StatelessWidget {
  final List<T> list;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget onEmpty;
  final int lenght;
  final Widget Function(BuildContext context, ValueKey key, T item) builder;
  const OtimizedListView({
    Key? key,
    required this.list,
    required this.builder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.onEmpty = const SizedBox.shrink(),
    this.shrinkWrap = false,
  })  : lenght = list.length,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return onEmpty;

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
            (context, i) {
              final item = list[i];
              final key = ValueKey(item);
              return builder(context, key, item);
            },
            childCount: list.length,
            addAutomaticKeepAlives: true,
            findChildIndexCallback: (key) {
              return list.indexWhere((m) => m == (key as ValueKey<T>).value);
            },
          ),
        ),
      ],
    );
  }
}
