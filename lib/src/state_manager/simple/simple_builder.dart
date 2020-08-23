import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'get_state.dart';

// It's a experimental feature
class SimpleBuilder extends StatefulWidget {
  final Widget Function(BuildContext) builder;
  const SimpleBuilder({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);
  @override
  _SimpleBuilderState createState() => _SimpleBuilderState();
}

class _SimpleBuilderState extends State<SimpleBuilder> {
  final HashSet<Disposer> disposers = HashSet<Disposer>();

  @override
  void dispose() {
    super.dispose();
    disposers.forEach((element) => element());
  }

  @override
  Widget build(BuildContext context) {
    return TaskManager.instance
        .exchange(disposers, setState, widget.builder, context);
  }
}

class TaskManager {
  TaskManager._();
  static TaskManager _instance;
  static TaskManager get instance => _instance ??= TaskManager._();

  StateSetter _setter;
  HashSet<Disposer> _remove;

  notify(HashSet<StateSetter> _updaters) {
    if (_setter != null) {
      if (!_updaters.contains(_setter)) {
        _updaters.add(_setter);
        _remove.add(() => _updaters.remove(_setter));
      }
    }
  }

  Widget exchange(
    HashSet<Disposer> disposers,
    StateSetter setState,
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
