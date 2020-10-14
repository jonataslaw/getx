import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

class Value<T> extends ListNotifier implements ValueListenable<T> {
  Value(this._value);

  T get value {
    notifyChildrens();
    return _value;
  }

  @override
  String toString() => value.toString();

  T _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    updater();
  }

  void update(void fn(T value)) {
    fn(value);
    updater();
  }
}

extension ReactiveT<T> on T {
  Value<T> get reactive => Value<T>(this);
}

typedef Condition = bool Function();

abstract class GetNotifier<T> extends Value<T> with GetLifeCycle {
  GetNotifier(T initial) : super(initial) {
    onStart.callback = _onStart;
    onDelete.callback = _onDelete;
    _fillEmptyStatus();
  }

  bool _initialized = false;

  /// Checks whether the controller has already been initialized.
  bool get initialized => _initialized;

  bool _isClosed = false;

  /// Checks whether the controller has already been closed.
  bool get isClosed => _isClosed;

  // Internal callback that starts the cycle of this controller.
  void _onStart() {
    if (_initialized) return;
    onInit();
    _initialized = true;
    SchedulerBinding.instance?.addPostFrameCallback((_) => onReady());
  }

  // Internal callback that starts the cycle of this controller.
  void _onDelete() {
    if (_isClosed) return;
    _isClosed = true;
    onClose();
  }

  RxStatus _status;

  bool get isNullOrEmpty {
    if (_value == null) return true;
    dynamic val = _value;
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

  void _fillEmptyStatus() {
    _status = isNullOrEmpty ? RxStatus.loading() : RxStatus.success();
  }

  RxStatus get status {
    // notifyChildrens();
    return _status;
  }

  Widget call(NotifierBuilder<T> widget, {Widget onError, Widget onLoading}) {
    return SimpleBuilder(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? CircularProgressIndicator();
      } else if (status.isError) {
        return onError ?? Text('A error occured');
      } else {
        if (widget == null) throw 'Widget cannot be null';
        return widget(value);
      }
    });
  }

  @protected
  void change(T newState, {RxStatus status}) {
    if (status != null) {
      _status = status;
    }
    if (newState != _value) {
      value = newState;
    }
  }

  dynamic toJson() => (value as dynamic)?.toJson();
}

class RxStatus {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final String errorMessage;
  RxStatus._({
    this.isLoading,
    this.isError,
    this.isSuccess,
    this.errorMessage,
  });

  factory RxStatus.loading() {
    return RxStatus._(
      isLoading: true,
      isError: false,
      isSuccess: false,
    );
  }

  factory RxStatus.success() {
    return RxStatus._(
      isLoading: false,
      isError: false,
      isSuccess: true,
    );
  }

  factory RxStatus.error([String message]) {
    return RxStatus._(
      isLoading: false,
      isError: true,
      isSuccess: false,
      errorMessage: message,
    );
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

