part of rx_stream;

/// [GetStream] is the lightest and most performative way of working
/// with events at Dart. You sintaxe is like StreamController, but it works
/// with simple callbacks. In this way, every event calls only one function.
/// There is no buffering, to very low memory consumption.
/// event [add] will add a object to stream. [addError] will add a error
/// to stream. [listen] is a very light StreamSubscription interface.
/// Is possible take the last value with [value] property.
class GetStream<T> {
  void Function() onListen;
  void Function() onPause;
  void Function() onResume;
  FutureOr<void> Function() onCancel;

  GetStream({this.onListen, this.onPause, this.onResume, this.onCancel});
  List<LightSubscription<T>> _onData = <LightSubscription<T>>[];

  bool _isBusy = false;

  FutureOr<bool> removeSubscription(LightSubscription<T> subs) async {
    if (!_isBusy) {
      return _onData.remove(subs);
    } else {
      await Future.delayed(Duration.zero);
      return _onData?.remove(subs);
    }
  }

  FutureOr<void> addSubscription(LightSubscription<T> subs) async {
    if (!_isBusy) {
      return _onData.add(subs);
    } else {
      await Future.delayed(Duration.zero);
      return _onData.add(subs);
    }
  }

  int get length => _onData?.length;

  bool get hasListeners => _onData.isNotEmpty;

  void _notifyData(T data) {
    _isBusy = true;
    for (final item in _onData) {
      if (!item.isPaused) {
        item._data?.call(data);
      }
    }
    _isBusy = false;
  }

  void _notifyError(Object error, [StackTrace stackTrace]) {
    assert(!isClosed, 'You cannot add errors to a closed stream.');
    _isBusy = true;
    var itemsToRemove = <LightSubscription<T>>[];
    for (final item in _onData) {
      if (!item.isPaused) {
        if (stackTrace != null) {
          item._onError?.call(error, stackTrace);
        } else {
          item._onError?.call(error);
        }

        if (item.cancelOnError) {
          //item.cancel?.call();
          itemsToRemove.add(item);
          item.pause();
          item._onDone?.call();
        }
      }
    }
    for (final item in itemsToRemove) {
      _onData.remove(item);
    }
    _isBusy = false;
  }

  void _notifyDone() {
    assert(!isClosed, 'You cannot close a closed stream.');
    _isBusy = true;
    for (final item in _onData) {
      if (!item.isPaused) {
        item._onDone?.call();
      }
    }
    _isBusy = false;
  }

  T _value;

  T get value => _value;

  void add(T event) {
    assert(!isClosed, 'You cannot add event to closed Stream');
    _value = event;
    _notifyData(event);
  }

  bool get isClosed => _onData == null;

  void addError(Object error, [StackTrace stackTrace]) {
    assert(!isClosed, 'You cannot add error to closed Stream');
    _notifyError(error, stackTrace);
  }

  void close() {
    assert(!isClosed, 'You cannot close a closed Stream');
    _notifyDone();
    _onData = null;
    _isBusy = null;
    _value = null;
  }

  LightSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    final subs = LightSubscription<T>(
      removeSubscription,
      onPause: onPause,
      onResume: onResume,
      onCancel: onCancel,
    )
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone)
      ..cancelOnError = cancelOnError;
    addSubscription(subs);
    onListen?.call();
    return subs;
  }

  Stream<T> get stream =>
      GetStreamTransformation(addSubscription, removeSubscription);
}

class LightSubscription<T> extends StreamSubscription<T> {
  final RemoveSubscription<T> _removeSubscription;
  LightSubscription(this._removeSubscription,
      {this.onPause, this.onResume, this.onCancel});
  final void Function() onPause;
  final void Function() onResume;
  final FutureOr<void> Function() onCancel;

  bool cancelOnError = false;

  @override
  Future<void> cancel() {
    _removeSubscription(this);
    onCancel?.call();
    return Future.value();
  }

  OnData<T> _data;

  Function _onError;

  Callback _onDone;

  bool _isPaused = false;

  @override
  void onData(OnData<T> handleData) => _data = handleData;

  @override
  void onError(Function handleError) => _onError = handleError;

  @override
  void onDone(Callback handleDone) => _onDone = handleDone;

  @override
  void pause([Future<void> resumeSignal]) {
    _isPaused = true;
    onPause?.call();
  }

  @override
  void resume() {
    _isPaused = false;
    onResume?.call();
  }

  @override
  bool get isPaused => _isPaused;

  @override
  Future<E> asFuture<E>([E futureValue]) => Future.value(futureValue);
}

class GetStreamTransformation<T> extends Stream<T> {
  final AddSubscription<T> _addSubscription;
  final RemoveSubscription<T> _removeSubscription;
  GetStreamTransformation(this._addSubscription, this._removeSubscription);

  @override
  LightSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    final subs = LightSubscription<T>(_removeSubscription)
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone);
    _addSubscription(subs);
    return subs;
  }
}

typedef RemoveSubscription<T> = FutureOr<bool> Function(
    LightSubscription<T> subs);

typedef AddSubscription<T> = FutureOr<void> Function(LightSubscription<T> subs);
