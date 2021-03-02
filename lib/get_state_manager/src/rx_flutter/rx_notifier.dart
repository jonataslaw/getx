import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

mixin StateMixin<T> on ListNotifier {
  T _value;
  RxStatus _status;

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

  void _fillEmptyStatus() {
    _status = _isNullOrEmpty(_value) ? RxStatus.loading() : RxStatus.success();
  }

  RxStatus get status {
    notifyChildrens();
    return _status ??= _status = RxStatus.loading();
  }

  T get state => value;

  @protected
  T get value {
    notifyChildrens();
    return _value;
  }

  @protected
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  @protected
  void change(T newState, {RxStatus status}) {
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
}

class Value<T> extends ListNotifier
    with StateMixin<T>
    implements ValueListenable<T> {
  Value(T val) {
    _value = val;
    _fillEmptyStatus();
  }

  @override
  T get value {
    notifyChildrens();
    return _value;
  }

  @override
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  T call([T v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  void update(void fn(T value)) {
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

typedef Condition = bool Function();

abstract class GetNotifier<T> extends Value<T> with GetLifeCycleBase {
  GetNotifier(T initial) : super(initial) {
    $configureLifeCycle();
  }

  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
    SchedulerBinding.instance?.addPostFrameCallback((_) => onReady());
  }
}

extension StateExt<T> on StateMixin<T> {
  Widget obx(
    NotifierBuilder<T> widget, {
    Widget Function(String error) onError,
    Widget onLoading,
    Widget onEmpty,
  }) {
    assert(widget != null);
    return SimpleBuilder(builder: (_) {
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
  final String errorMessage;

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

  factory RxStatus.error([String message]) {
    return RxStatus._(isError: true, errorMessage: message);
  }

  factory RxStatus.empty() {
    return RxStatus._(isEmpty: true);
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);
