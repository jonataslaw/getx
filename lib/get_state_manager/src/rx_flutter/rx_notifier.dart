import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';
import 'get_status.dart';

extension _Empty on Object {
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
  T? _value;
  GetStatus<T>? _status;

  void _fillInitialStatus() {
    _status = (_value == null || _value!._isEmpty())
        ? GetStatus<T>.loading()
        : GetStatus<T>.success(_value as T);
  }

  GetStatus<T> get status {
    reportRead();
    return _status ??= _status = GetStatus.loading();
  }

  T get state => value;

  set status(GetStatus<T> newStatus) {
    if (newStatus == status) return;
    _status = newStatus;
    if (newStatus is SuccessStatus<T>) {
      _value = newStatus.data;
    }
    refresh();
  }

  @protected
  T get value {
    reportRead();
    return _value as T;
  }

  @protected
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  @protected
  void change(GetStatus<T> status) {
    if (status != this.status) {
      this.status = status;
    }
  }

  void setSuccess(T data) {
    change(GetStatus<T>.success(data));
  }

  void setError(Object error) {
    change(GetStatus<T>.error(error));
  }

  void setLoading() {
    change(GetStatus<T>.loading());
  }

  void setEmpty() {
    change(GetStatus<T>.empty());
  }

  /// Executes the given async function and updates the status accordingly
  Future<T> futurize(
    Future<T> Function() body, {
    T? initialData,
    String? errorMessage,
    bool useEmpty = true,
  }) async {
    _value ??= initialData;
    change(GetStatus<T>.loading());
    
    try {
      final newValue = await body();
      
      if (useEmpty && (newValue == null || newValue._isEmpty())) {
        change(GetStatus<T>.empty());
      } else {
        change(GetStatus<T>.success(newValue));
      }
      
      return newValue;
    } catch (err) {
      final error = errorMessage != null 
          ? Exception('$errorMessage: ${err.toString()}')
          : err is Exception ? err : Exception(err.toString());
      change(GetStatus<T>.error(error));
      rethrow;
    } finally {
      refresh();
    }
  }
}

typedef FuturizeCallback<T> = Future<T> Function(VoidCallback fn);

typedef VoidCallback = void Function();

class GetListenable<T> extends ListNotifierSingle implements RxInterface<T> {
  GetListenable(T val) : _value = val;

  StreamController<T>? _controller;

  StreamController<T> get subject {
    if (_controller == null) {
      _controller = StreamController<T>.broadcast(
        onCancel: addListener(_streamListener),
      );
      _controller?.add(_value);
    }
    return _controller!;
  }

  void _streamListener() {
    _controller?.add(_value);
  }

  @override
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

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => stream.listen(
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
    _fillInitialStatus();
  }

  @override
  T get value {
    reportRead();
    return _value as T;
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

  void update(T Function(T? value) fn) {
    value = fn(value);
    // refresh();
  }

  @override
  String toString() => value.toString();

  dynamic toJson() => (value as dynamic)?.toJson();
}

/// GetNotifier has a native status and state implementation, with the
/// Get Lifecycle
abstract class GetNotifier<T> extends Value<T> with GetLifeCycleMixin {
  GetNotifier(super.initial);
}

extension StateExt<T> on StateMixin<T> {
  Widget obx(
    NotifierBuilder<T> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    WidgetBuilder? onCustom,
  }) {
    return Observer(
      builder: (context) {
        return status.when<Widget>(
          loading: () =>
              onLoading ?? const Center(child: CircularProgressIndicator()),
          error: (error) => onError != null
              ? onError(error?.toString())
              : Center(
                  child: Text('An error occurred: ${error ?? "Unknown error"}'),
                ),
          empty: () => onEmpty ?? const SizedBox.shrink(),
          success: (data) => widget(data),
          custom: () => onCustom?.call(context) ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);
