import 'dart:collection';

import 'package:flutter/foundation.dart';

// This callback remove the listener on addListener function
typedef Disposer = void Function();

// replacing StateSetter, return if the Widget is mounted for extra validation.
// if it brings overhead the extra call,
typedef GetStateUpdate = void Function();

class ListNotifier extends Listenable
    with ListNotifierSingleMixin, ListNotifierGroupMixin {}

class ListNotifierSingle = ListNotifier with ListNotifierSingleMixin;

class ListNotifierGroup = ListNotifier with ListNotifierGroupMixin;

mixin ListNotifierSingleMixin on Listenable {
  List<GetStateUpdate?>? _updaters = <GetStateUpdate?>[];

  @override
  Disposer addListener(GetStateUpdate listener) {
    assert(_debugAssertNotDisposed());
    _updaters!.add(listener);
    return () => _updaters!.remove(listener);
  }

  bool containsListener(GetStateUpdate listener) {
    return _updaters?.contains(listener) ?? false;
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _updaters!.remove(listener);
  }

  @protected
  void refresh() {
    assert(_debugAssertNotDisposed());
    _notifyUpdate();
  }

  @protected
  void reportRead() {
    TaskManager.instance.notify(this);
  }

  void _notifyUpdate() {
    for (var element in _updaters!) {
      element!();
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

  int get listenersLength {
    assert(_debugAssertNotDisposed());
    return _updaters!.length;
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _updaters = null;
  }
}

mixin ListNotifierGroupMixin on Listenable {
  HashMap<Object?, ListNotifierSingleMixin>? _updatersGroupIds =
      HashMap<Object?, ListNotifierSingleMixin>();

  void _notifyGroupUpdate(Object id) {
    if (_updatersGroupIds!.containsKey(id)) {
      _updatersGroupIds![id]!._notifyUpdate();
    }
  }

  @protected
  void notifyGroupChildrens(Object id) {
    assert(_debugAssertNotDisposed());
    TaskManager.instance.notify(_updatersGroupIds![id]!);
  }

  bool containsId(Object id) {
    return _updatersGroupIds?.containsKey(id) ?? false;
  }

  @protected
  void refreshGroup(Object id) {
    assert(_debugAssertNotDisposed());
    _notifyGroupUpdate(id);
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_updatersGroupIds == null) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
'Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  void removeListenerId(Object id, VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    if (_updatersGroupIds!.containsKey(id)) {
      _updatersGroupIds![id]!.removeListener(listener);
    }
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _updatersGroupIds?.forEach((key, value) => value.dispose());
    _updatersGroupIds = null;
  }

  Disposer addListenerId(Object? key, GetStateUpdate listener) {
    _updatersGroupIds![key] ??= ListNotifierSingle();
    return _updatersGroupIds![key]!.addListener(listener);
  }

  /// To dispose an [id] from future updates(), this ids are registered
  /// by `GetBuilder()` or similar, so is a way to unlink the state change with
  /// the Widget from the Controller.
  void disposeId(Object id) {
    _updatersGroupIds?[id]?.dispose();
    _updatersGroupIds!.remove(id);
  }
}

class TaskManager {
  TaskManager._();

  static TaskManager? _instance;

  static TaskManager get instance => _instance ??= TaskManager._();

  GetStateUpdate? _setter;
  List<VoidCallback>? _remove;

  final listNotifier = ListNotifierGroup();

  // void addElement(Object id, GetStateUpdate listener) {
  //   _remove?.add(listNotifier.addListenerId(id, listener));
  // }

  void notify(ListNotifierSingleMixin _updaters) {
    final listener = _setter;
    if (listener != null) {
      if (!_updaters.containsListener(listener)) {
        _updaters.addListener(listener);
        _remove?.add(() => _updaters.removeListener(listener));
      }
    }
  }

  T exchange<T>(List<VoidCallback> disposers, GetStateUpdate setState,
      T Function() builder) {
    _remove = disposers;
    _setter = setState;
    final result = builder();
    _remove = null;
    _setter = null;
    return result;
  }
}
