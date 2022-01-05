import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  late T _value;
  GetState<T>? _status;

  void _fillInitialStatus() {
    _status = (state == null || state!._isEmpty())
        ? GetState<T>.loading()
        : GetState<T>.success(_value);
  }

  GetState<T> get status {
    reportRead();
    return _status ??= _status = GetState.loading();
  }

//  T get state => value;

  set status(GetState<T> newStatus) {
    if (newStatus == status) return;
    _status = newStatus;
    if (newStatus is SuccessState<T>) {
      _value = newStatus.data!;
    }
    refresh();
  }

  @protected
  T get state {
    reportRead();
    return _value;
  }

  @protected
  set state(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  void futurize(Future<T> Function() body(),
      {String? errorMessage, bool useEmpty = true}) {
    final compute = body();
    compute().then((newValue) {
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        status = GetState<T>.loading();
      } else {
        status = GetState<T>.success(newValue);
      }
    }, onError: (err) {
      status = GetState.error(errorMessage ?? err.toString());
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
    _fillInitialStatus();
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
      return widget(state);
    });
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GetState<T> {
  const GetState();
  factory GetState.loading() => LoadingState();
  factory GetState.error(Object message) => ErrorState(message);
  factory GetState.empty() => EmptyState();
  factory GetState.success(T data) => SuccessState(data);
}

class LoadingState<T> extends GetState<T> {}

class SuccessState<T> extends GetState<T> {
  final T data;

  SuccessState(this.data);
}

class ErrorState<T, S> extends GetState<T> {
  final S? error;
  ErrorState([this.error]);
}

class EmptyState<T> extends GetState<T> {}

extension StatusDataExt<T> on GetState<T> {
  bool get isLoading => this is LoadingState;
  bool get isSuccess => this is SuccessState;
  bool get isError => this is ErrorState;
  bool get isEmpty => this is EmptyState;
  String get errorMessage {
    final isError = this is ErrorState;
    if (isError) {
      final err = this as ErrorState;
      if (err.error != null && err.error is String) {
        return err.error as String;
      }
    }

    return '';
  }

  T? get data {
    if (this is SuccessState<T>) {
      final success = this as SuccessState<T>;
      return success.data;
    }
    return null;
  }
}
