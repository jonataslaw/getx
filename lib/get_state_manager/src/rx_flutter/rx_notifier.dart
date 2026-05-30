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

  void futurize(
    Future<T> Function() body, {
    T? initialData,
    String? errorMessage,
    bool useEmpty = true,
  }) {
    final compute = body;
    _value ??= initialData;
    status = GetStatus<T>.loading();
    compute().then(
      (newValue) {
        if ((newValue == null || newValue._isEmpty()) && useEmpty) {
          status = GetStatus<T>.empty();
        } else {
          status = GetStatus<T>.success(newValue);
        }

        refresh();
      },
      onError: (err) {
        status = GetStatus.error(
          err is Exception ? err : Exception(errorMessage ?? err.toString()),
        );
        refresh();
      },
    );
  }
}

typedef FuturizeCallback<T> = Future<T> Function(VoidCallback fn);

class GetListenable<T> extends ListNotifierSingle implements RxInterface<T> {
  GetListenable(T val) : _value = val;

  StreamController<T>? _controller;

  StreamController<T> get subject {
    if (_controller == null) {
      _controller = StreamController<T>.broadcast(
        onCancel: addListener(_streamListener),
      );
      _controller?.add(_value);

      /// Report to controller dispose
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

  dynamic toJson() {
    final val = value;
    if (val == null) return null;
    try {
      // ignore: avoid_dynamic_calls
      return (val as dynamic).toJson();
    } catch (_) {
      return null;
    }
  }
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
        final currentStatus = status;
        return switch (currentStatus) {
          LoadingStatus<T>() =>
            onLoading ?? const Center(child: CircularProgressIndicator()),
          ErrorStatus<T>() =>
            onError != null
                ? onError(currentStatus.errorMessage)
                : Center(
                    child: Text(
                      'An error occurred: ${currentStatus.errorMessage}',
                    ),
                  ),
          EmptyStatus<T>() => onEmpty ?? const SizedBox.shrink(),
          SuccessStatus<T>() => widget(value),
          CustomStatus<T>() =>
            onCustom?.call(context) ?? const SizedBox.shrink(),
        };
      },
    );
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

sealed class GetStatus<T> {
  const GetStatus();

  factory GetStatus.loading() => LoadingStatus<T>();

  factory GetStatus.error(Object message) => ErrorStatus<T>(message);

  factory GetStatus.empty() => EmptyStatus<T>();

  factory GetStatus.success(T data) => SuccessStatus<T>(data);

  factory GetStatus.custom() => CustomStatus<T>();
}

final class CustomStatus<T> extends GetStatus<T> {
  const CustomStatus();

  @override
  bool operator ==(Object other) => other is CustomStatus<T>;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class LoadingStatus<T> extends GetStatus<T> {
  const LoadingStatus();

  @override
  bool operator ==(Object other) => other is LoadingStatus<T>;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class SuccessStatus<T> extends GetStatus<T> {
  final T data;

  const SuccessStatus(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SuccessStatus<T> && other.data == data;

  @override
  int get hashCode => data.hashCode;
}

final class ErrorStatus<T> extends GetStatus<T> {
  final Object? error;

  const ErrorStatus([this.error]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ErrorStatus<T> && other.error == error;

  @override
  int get hashCode => error.hashCode;
}

final class EmptyStatus<T> extends GetStatus<T> {
  const EmptyStatus();

  @override
  bool operator ==(Object other) => other is EmptyStatus<T>;

  @override
  int get hashCode => runtimeType.hashCode;
}

extension StatusDataExt<T> on GetStatus<T> {
  bool get isLoading => this is LoadingStatus<T>;

  bool get isSuccess => this is SuccessStatus<T>;

  bool get isError => this is ErrorStatus<T>;

  bool get isEmpty => this is EmptyStatus<T>;

  bool get isCustom => this is CustomStatus<T>;

  Object? get error {
    final current = this;
    if (current is ErrorStatus<T>) {
      return current.error;
    }
    return null;
  }

  String get errorMessage {
    final current = this;
    if (current is ErrorStatus<T>) {
      final err = current.error;
      if (err != null) {
        if (err is String) {
          return err;
        }
        return err.toString();
      }
    }
    return '';
  }

  T? get data {
    final current = this;
    if (current is SuccessStatus<T>) {
      return current.data;
    }
    return null;
  }
}
