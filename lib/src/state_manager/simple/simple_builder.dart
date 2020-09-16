import 'dart:async';
import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'get_state.dart';

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
  final T initialValue;
  final ValueBuilderBuilder<T> builder;
  final void Function() onDispose;
  final void Function(T) onUpdate;

  const ValueBuilder({
    Key key,
    this.initialValue,
    this.onDispose,
    this.onUpdate,
    @required this.builder,
  }) : super(key: key);

  @override
  _ValueBuilderState<T> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends State<ValueBuilder<T>> {
  T value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => widget.builder(value, updater);

  void updater(T newValue) {
    if (widget.onUpdate != null) {
      widget.onUpdate(newValue);
    }
    setState(() {
      value = newValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget?.onDispose?.call();
    if (value is ChangeNotifier) {
      (value as ChangeNotifier)?.dispose();
    } else if (value is StreamController) {
      (value as StreamController)?.close();
    }
    value = null;
  }
}

// It's a experimental feature
class SimpleBuilder extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const SimpleBuilder({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  @override
  _SimpleBuilderState createState() => _SimpleBuilderState();
}

class _SimpleBuilderState extends State<SimpleBuilder>
    with GetStateUpdaterMixin {
  final HashSet<VoidCallback> disposers = HashSet<VoidCallback>();

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

class TaskManager {
  TaskManager._();

  static TaskManager _instance;

  static TaskManager get instance => _instance ??= TaskManager._();

//  StateSetter _setter;//<old>
  GetStateUpdate _setter;

  HashSet<VoidCallback> _remove;

//  void notify(HashSet<StateSetter> _updaters) { //<old>
  void notify(HashSet<GetStateUpdate> _updaters) {
    if (_setter != null) {
      if (!_updaters.contains(_setter)) {
        _updaters.add(_setter);
        _remove.add(() => _updaters.remove(_setter));
      }
    }
  }

  Widget exchange(
    HashSet<VoidCallback> disposers,
//    StateSetter setState, //<old>
    GetStateUpdate setState,
    Widget Function(BuildContext) builder,
    BuildContext context,
  ) {
    _remove = disposers;
    _setter = setState;
    final result = builder(context);
    _remove = null;
    _setter = null;
    return result;
  }
}
