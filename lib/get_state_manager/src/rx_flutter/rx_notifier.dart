import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

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
        : GetStatus<T>.success(_value!);
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
      _value = newStatus.data!;
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
    // var _canUpdate = false;
    // if (status != null) {
    //   _status = status;
    //   _canUpdate = true;
    // }
    // if (newState != _value) {
    //   _value = newState;
    //   _canUpdate = true;
    // }
    // if (_canUpdate) {
    //   refresh();
    // }
  }

  void futurize(Future<T> Function() Function() body,
      {String? errorMessage, bool useEmpty = true}) {
    final compute = body();
    compute().then((newValue) {
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        status = GetStatus<T>.loading();
      } else {
        status = GetStatus<T>.success(newValue);
      }

      refresh();
    }, onError: (err) {
      status = GetStatus.error(errorMessage ?? err.toString());
      refresh();
    });
  }
}

class GetListenable<T> extends ListNotifierSingle implements RxInterface<T> {
  GetListenable(T val) : _value = val;

  StreamController<T>? _controller;

  StreamController<T> get subject {
    if (_controller == null) {
      _controller =
          StreamController<T>.broadcast(onCancel: addListener(_streamListener));
      _controller?.add(_value);

      ///TODO: report to controller dispose
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
  GetNotifier(T initial) : super(initial);
}

extension StateExt<T> on StateMixin<T> {
  Widget obx(
    NotifierBuilder<T?> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    WidgetBuilder? onCustom,
  }) {
    return Observer(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return onError != null
            ? onError(status.errorMessage)
            : Center(child: Text('A error occurred: ${status.errorMessage}'));
      } else if (status.isEmpty) {
        return onEmpty ??
            SizedBox.shrink(); // Also can be widget(null); but is risky
      } else if (status.isSuccess) {
        return widget(value);
      } else if (status.isCustom) {
        return onCustom?.call(_) ??
            SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(value);
    });
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GetStatus<T> {
  const GetStatus();
  factory GetStatus.loading() => LoadingStatus();
  factory GetStatus.error(String message) => ErrorStatus(message);
  factory GetStatus.empty() => EmptyStatus();
  factory GetStatus.success(T data) => SuccessStatus(data);
}

class LoadingStatus<T> extends GetStatus<T> {}

class SuccessStatus<T> extends GetStatus<T> {
  final T data;

  SuccessStatus(this.data);
}

class ErrorStatus<T, S> extends GetStatus<T> {
  final S? error;
  ErrorStatus([this.error]);
}

class EmptyStatus<T> extends GetStatus<T> {}

extension StatusDataExt<T> on GetStatus<T> {
  bool get isLoading => this is LoadingStatus;
  bool get isSuccess => this is SuccessStatus;
  bool get isError => this is ErrorStatus;
  bool get isEmpty => this is EmptyStatus;
  bool get isCustom => !isLoading && !isSuccess && !isError && !isEmpty;
  String get errorMessage {
    final isError = this is ErrorStatus;
    if (isError) {
      final err = this as ErrorStatus;
      if (err.error != null && err.error is String) {
        return err.error as String;
      }
    }

    return '';
  }

  T? get data {
    if (this is SuccessStatus<T>) {
      final success = this as SuccessStatus<T>;
      return success.data;
    }
    return null;
  }
}
