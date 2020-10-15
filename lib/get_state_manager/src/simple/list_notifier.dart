import 'package:flutter/foundation.dart';

import 'simple_builder.dart';

class ListNotifier implements Listenable {
  List<VoidCallback> _listeners = <VoidCallback>[];

  @protected
  void updater() {
    assert(_debugAssertNotDisposed());
    for (var element in _listeners) {
      element();
    }
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
'Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  @protected
  void notifyChildrens() {
    TaskManager.instance.notify(_listeners);
  }

  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners.isNotEmpty;
  }

  @override
  void addListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _listeners.remove(listener);
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }
}
