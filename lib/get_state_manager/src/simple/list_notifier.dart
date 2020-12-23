import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// This callback remove the listener on addListener function
typedef Disposer = void Function();

// replacing StateSetter, return if the Widget is mounted for extra validation.
// if it brings overhead the extra call,
typedef GetStateUpdate = void Function();

class ListNotifier implements Listenable {
  int _version = 0;
  int _microtask = 0;

  int get notifierVersion => _version;
  int get notifierMicrotask => _microtask;

  List<GetStateUpdate> _updaters = <GetStateUpdate>[];

  HashMap<String, List<GetStateUpdate>> _updatersGroupIds =
      HashMap<String, List<GetStateUpdate>>();

  @protected
  void refresh() {
    assert(_debugAssertNotDisposed());

    /// This debounce the call to update.
    /// It prevent errors and duplicates builds
    if (_microtask == _version) {
      _microtask++;
      scheduleMicrotask(() {
        _version++;
        _microtask = _version;
        _notifyUpdate();
      });
    }
  }

  void _notifyUpdate() {
    for (var element in _updaters) {
      element();
    }
  }

  void _notifyIdUpdate(String id) {
    if (_updatersGroupIds.containsKey(id)) {
      final listGroup = _updatersGroupIds[id];
      for (var item in listGroup) {
        item();
      }
    }
  }

  @protected
  void refreshGroup(String id) {
    assert(_debugAssertNotDisposed());

    /// This debounce the call to update.
    /// It prevent errors and duplicates builds
    if (_microtask == _version) {
      _microtask++;
      scheduleMicrotask(() {
        _version++;
        _microtask = _version;
        _notifyIdUpdate(id);
      });
    }
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_updaters == null) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
'Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  @protected
  void notifyChildrens() {
    TaskManager.instance.notify(_updaters);
  }

  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _updaters.isNotEmpty;
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _updaters.remove(listener);
  }

  void removeListenerId(String id, VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    if (_updatersGroupIds.containsKey(id)) {
      _updatersGroupIds[id].remove(listener);
    }
    _updaters.remove(listener);
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _updaters = null;
    _updatersGroupIds = null;
  }

  @override
  Disposer addListener(GetStateUpdate listener) {
    assert(_debugAssertNotDisposed());
    _updaters.add(listener);
    return () => _updaters.remove(listener);
  }

  Disposer addListenerId(String key, GetStateUpdate listener) {
    _updatersGroupIds[key] ??= <GetStateUpdate>[];
    _updatersGroupIds[key].add(listener);
    return () => _updatersGroupIds[key].remove(listener);
  }

  /// To dispose an [id] from future updates(), this ids are registered
  /// by [GetBuilder()] or similar, so is a way to unlink the state change with
  /// the Widget from the Controller.
  void disposeId(String id) {
    _updatersGroupIds.remove(id);
  }
}

class TaskManager {
  TaskManager._();

  static TaskManager _instance;

  static TaskManager get instance => _instance ??= TaskManager._();

  GetStateUpdate _setter;

  List<VoidCallback> _remove;

  void notify(List<GetStateUpdate> _updaters) {
    if (_setter != null) {
      if (!_updaters.contains(_setter)) {
        _updaters.add(_setter);
        _remove.add(() => _updaters.remove(_setter));
      }
    }
  }

  Widget exchange(
    List<VoidCallback> disposers,
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
