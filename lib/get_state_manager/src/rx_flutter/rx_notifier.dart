import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

extension _NullOrEmpty on Object {
  bool _isEmpty() {
    final val = this;
    // if (val == null) return true;
    var result = false;
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.trim().isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }
}

mixin StateMixin<T> on ListNotifier {
  late T _value;
  GetState? _status;

  void _fillEmptyStatus() {
    _status = (value == null || value!._isEmpty())
        ? GetState.loading()
        : GetState.success(_status);
  }

  GetState get status {
    reportRead();
    return _status ??= _status = GetState.loading();
  }

  T get state => value;

  @protected
  T get value {
    reportRead();
    return _value;
  }

  @protected
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  @protected
  void change(T newState, {GetState? status}) {
    var _canUpdate = false;
    if (status != null) {
      _status = status;
      _canUpdate = true;
    }
    if (newState != _value) {
      _value = newState;
      _canUpdate = true;
    }
    if (_canUpdate) {
      refresh();
    }
  }

  void listenFuture(Future<T> Function() body(),
      {String? errorMessage, bool useEmpty = true}) {
    final compute = body();
    compute().then((newValue) {
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        change(newValue, status: GetState.loading());
      } else {
        change(newValue, status: GetState.success(newValue));
      }
    }, onError: (err) {
      change(state, status: GetState.error(errorMessage ?? err.toString()));
    });
  }
}

class GetListenable<T> extends ListNotifierSingle
    implements ValueListenable<T> {
  GetListenable(T val) : _value = val;

  StreamController<T>? _controller;

  StreamController<T> get subject {
    if (_controller == null) {
      _controller = StreamController<T>.broadcast();
      addListener(_streamListener);
    }
    return _controller!;
  }

  void _streamListener() {
    _controller?.add(_value);
  }

  @mustCallSuper
  void close() {
    removeListener(_streamListener);
    _controller?.close();
    dispose();
  }

  Stream<T> get stream {
    return subject.stream;
  }

  T _value;

  @override
  T get value {
    reportRead();
    return _value;
  }

  void _notify() {
    refresh();
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    _notify();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError ?? false,
      );

  @override
  String toString() => value.toString();
}

class Value<T> extends ListNotifier
    with StateMixin<T>
    implements ValueListenable<T?> {
  Value(T val) {
    _value = val;
    _fillEmptyStatus();
  }

  @override
  T get value {
    reportRead();
    return _value;
  }

  @override
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  void update(void fn(T? value)) {
    fn(value);
    refresh();
  }

  @override
  String toString() => value.toString();

  dynamic toJson() => (value as dynamic)?.toJson();
}

abstract class GetNotifier<T> extends Value<T> with GetLifeCycleMixin {
  GetNotifier(T initial) : super(initial);
}

extension StateExt<T> on StateMixin<T> {
  Widget obx(
    NotifierBuilder<T?> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
  }) {
    return Observer(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return onError != null
            ? onError(status.errorMessage)
            : Center(child: Text('A error occurred: ${status.errorMessage}'));
      } else if (status.isEmpty) {
        return onEmpty != null
            ? onEmpty
            : SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(value);
    });
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GetState<T> {
  const GetState();
  factory GetState.loading() => GLoading();
  factory GetState.error(String message) => GError(message);
  factory GetState.empty() => GEmpty();
  factory GetState.success(T data) => GSuccess(data);
}

class GLoading<T> extends GetState<T> {}

class GSuccess<T> extends GetState<T> {
  final T data;

  GSuccess(this.data);
}

class GError<T, S> extends GetState<T> {
  final S? error;
  GError([this.error]);
}

class GEmpty<T> extends GetState<T> {}

extension StatusDataExt<T> on GetState<T> {
  bool get isLoading => this is GLoading;
  bool get isSuccess => this is GSuccess;
  bool get isError => this is GError;
  bool get isEmpty => this is GEmpty;
  String get errorMessage {
    final isError = this is GError;
    if (isError) {
      final err = this as GError;
      if (err.error != null && err.error is String) {
        return err.error as String;
      }
    }

    return '';
  }
}
