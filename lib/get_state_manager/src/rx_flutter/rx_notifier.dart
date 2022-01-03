import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

extension _NullOrEmpty on Object {
  bool _isNullOrEmpty(dynamic val) {
    if (val == null) return true;
    var result = false;
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }
}

mixin StateMixin<T> on ListNotifier {
  late T _value;
  RxStatus? _status;

  void _fillEmptyStatus() {
    _status = _isNullOrEmpty(_value) ? RxStatus.loading() : RxStatus.success();
  }

  RxStatus get status {
    reportRead();
    return _status ??= _status = RxStatus.loading();
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
  void change(T newState, {RxStatus? status}) {
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

  void append(Future<T> Function() body(), {String? errorMessage}) {
    final compute = body();
    compute().then((newValue) {
      change(newValue, status: RxStatus.success());
    }, onError: (err) {
      change(state, status: RxStatus.error(errorMessage ?? err.toString()));
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

extension ReactiveT<T> on T {
  Value<T> get reactive => Value<T>(this);
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

class RxStatus {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final bool isEmpty;
  final bool isLoadingMore;
  final String? errorMessage;

  RxStatus._({
    this.isEmpty = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isLoadingMore = false,
  });

  factory RxStatus.loading() {
    return RxStatus._(isLoading: true);
  }

  factory RxStatus.loadingMore() {
    return RxStatus._(isSuccess: true, isLoadingMore: true);
  }

  factory RxStatus.success() {
    return RxStatus._(isSuccess: true);
  }

  factory RxStatus.error([String? message]) {
    return RxStatus._(isError: true, errorMessage: message);
  }

  factory RxStatus.empty() {
    return RxStatus._(isEmpty: true);
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GState<T> {
  const GState();
  factory GState.loading() => GLoading();
  factory GState.error(String message) => GError(message);
  factory GState.empty() => GEmpty();
  factory GState.success(T data) => GSuccess(data);
}

class GLoading<T> extends GState<T> {}

class GSuccess<T> extends GState<T> {
  final T data;

  GSuccess(this.data);
}

class GError<T, S> extends GState<T> {
  final S? error;
  GError([this.error]);
}

class GEmpty<T> extends GState<T> {}

extension StatusDataExt<T> on GState<T> {
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
