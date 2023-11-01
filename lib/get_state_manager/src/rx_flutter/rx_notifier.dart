import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../../../instance_manager.dart';
import '../../../utils.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

extension _Empty on Object {
  bool _isEmpty() {
    final Object val = this;
    // if (val == null) return true;
    bool result = false;
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
    return _status ??= _status = GetStatus<T>.loading();
  }

  T get state => value;

  set status(final GetStatus<T> newStatus) {
    if (newStatus == status) {
      return;
    }
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
  set value(final T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    refresh();
  }

  @protected
  void change(final GetStatus<T> status) {
    if (status != this.status) {
      this.status = status;
    }
  }

  void futurize(final Future<T> Function() body,
      {final T? initialData, final String? errorMessage, final bool useEmpty = true,}) {
    final Future<T> Function() compute = body;
    _value ??= initialData;
    compute().then((final T newValue) {
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        status = GetStatus<T>.loading();
      } else {
        status = GetStatus<T>.success(newValue);
      }

      refresh();
    }, onError: (final err) {
      status = GetStatus<T>.error(errorMessage ?? err.toString());
      refresh();
    },);
  }
}

typedef FuturizeCallback<T> = Future<T> Function(VoidCallback fn);

typedef VoidCallback = void Function();

class GetListenable<T> extends ListNotifierSingle implements RxInterface<T> {
  GetListenable(final T val) : _value = val;

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

  set value(final T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    _notify();
  }

  T? call([final T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  @override
  StreamSubscription<T> listen(
    final void Function(T)? onData, {
    final Function? onError,
    final void Function()? onDone,
    final bool? cancelOnError,
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
  Value(final T val) {
    _value = val;
    _fillInitialStatus();
  }

  @override
  T get value {
    reportRead();
    return _value as T;
  }

  @override
  set value(final T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    refresh();
  }

  T? call([final T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  void update(final T Function(T? value) fn) {
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
    final NotifierBuilder<T?> widget, {
    final Widget Function(String? error)? onError,
    final Widget? onLoading,
    final Widget? onEmpty,
    final WidgetBuilder? onCustom,
  }) {
    return Observer(builder: (final _) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return onError != null
            ? onError(status.errorMessage)
            : Center(child: Text('A error occurred: ${status.errorMessage}'));
      } else if (status.isEmpty) {
        return onEmpty ??
            const SizedBox.shrink(); // Also can be widget(null); but is risky
      } else if (status.isSuccess) {
        return widget(value);
      } else if (status.isCustom) {
        return onCustom?.call(_) ??
            const SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(value);
    },);
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GetStatus<T> with Equality {
  const GetStatus();
  factory GetStatus.loading() => LoadingStatus<T>();
  factory GetStatus.error(final String message) => ErrorStatus<T, String>(message);
  factory GetStatus.empty() => EmptyStatus<T>();
  factory GetStatus.success(final T data) => SuccessStatus<T>(data);
  factory GetStatus.custom() => CustomStatus<T>();
}

class CustomStatus<T> extends GetStatus<T> {
  @override
  List<T> get props => <T>[];
}

class LoadingStatus<T> extends GetStatus<T> {
  @override
  List<T> get props => <T>[];
}

class SuccessStatus<T> extends GetStatus<T> {
  const SuccessStatus(this.data);
  final T data;

  @override
  List<T> get props => <T>[data];
}

class ErrorStatus<T, S> extends GetStatus<T> {
  const ErrorStatus([this.error]);
  final S? error;

  @override
  List<S?> get props => <S?>[error];
}

class EmptyStatus<T> extends GetStatus<T> {
  @override
  List<T> get props => <T>[];
}

extension StatusDataExt<T> on GetStatus<T> {
  bool get isLoading => this is LoadingStatus;
  bool get isSuccess => this is SuccessStatus;
  bool get isError => this is ErrorStatus;
  bool get isEmpty => this is EmptyStatus;
  bool get isCustom => !isLoading && !isSuccess && !isError && !isEmpty;
  String get errorMessage {
    final bool isError = this is ErrorStatus;
    if (isError) {
      final ErrorStatus<T, T> err = this as ErrorStatus<T, T>;
      if (err.error != null && err.error is String) {
        return err.error! as String;
      }
    }

    return '';
  }

  T? get data {
    if (this is SuccessStatus<T>) {
      final SuccessStatus<T> success = this as SuccessStatus<T>;
      return success.data;
    }
    return null;
  }
}
