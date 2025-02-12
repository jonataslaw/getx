import 'dart:async';

import 'package:flutter/widgets.dart';

import 'get_state.dart';
import 'list_notifier.dart';

typedef ValueBuilderUpdateCallback<T> = void Function(T snapshot);
typedef ValueBuilderBuilder<T> = Widget Function(
    T snapshot, ValueBuilderUpdateCallback<T> updater);

/// Manages a local state like ObxValue, but uses a callback instead of
/// a Rx value.
///
/// Example:
/// ```
///  ValueBuilder<bool>(
///    initialValue: false,
///    builder: (value, update) => Switch(
///    value: value,
///    onChanged: (flag) {
///       update( flag );
///    },),
///    onUpdate: (value) => print("Value updated: $value"),
///  ),
///  ```
class ValueBuilder<T> extends StatefulWidget {
  final T? initialValue;
  final ValueBuilderBuilder<T> builder;
  final void Function()? onDispose;
  final void Function(T)? onUpdate;

  const ValueBuilder({
    Key? key,
    this.initialValue,
    this.onDispose,
    this.onUpdate,
    required this.builder,
  }) : super(key: key);

  @override
  ValueBuilderState<T> createState() => ValueBuilderState<T>();
}

class ValueBuilderState<T> extends State<ValueBuilder<T?>> {
  T? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => widget.builder(value, updater);

  void updater(T? newValue) {
    if (widget.onUpdate != null) {
      widget.onUpdate!(newValue);
    }
    setState(() {
      value = newValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call();
    if (value is ChangeNotifier) {
      (value as ChangeNotifier?)?.dispose();
    } else if (value is StreamController) {
      (value as StreamController?)?.close();
    }
    value = null;
  }
}

// It's a experimental feature
class SimpleBuilder extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const SimpleBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  SimpleBuilderState createState() => SimpleBuilderState();
}

class SimpleBuilderState extends State<SimpleBuilder>
    with GetStateUpdaterMixin {
  final disposers = <Disposer>[];

  @override
  void dispose() {
    super.dispose();
    for (final disposer in disposers) {
      disposer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskManager.instance.exchange(
      disposers,
      getUpdate,
      widget.builder,
      context,
    );
  }
}
