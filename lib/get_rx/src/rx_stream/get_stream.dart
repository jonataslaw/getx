part of rx_stream;

/// [GetStream] is the lightest and most performative way of working
/// with events at Dart. You sintaxe is like StreamController, but it works
/// with simple callbacks. In this way, every event calls only one function.
/// There is no buffering, to very low memory consumption.
/// event [add] will add a object to stream. [addError] will add a error
/// to stream. [listen] is a very light StreamSubscription interface.
/// Is possible take the last value with [value] property.
class GetStream<T> {
  LightListenable<T> listenable = LightListenable<T>();

  T _value;

  T get value => _value;

  void add(T event) {
    _value = event;
    _checkIfDisposed();
    listenable.notifyData(event);
  }

  void _checkIfDisposed([bool isClosed = false]) {
    if (listenable == null) {
      throw '''[LightStream] Error: 
You cannot ${isClosed ? "close" : "add events to"} a closed stream.''';
    }
  }

  void addError(Object error, [StackTrace stackTrace]) {
    _checkIfDisposed();
    listenable.notifyError(error, stackTrace);
  }

  void close() {
    _checkIfDisposed(true);
    listenable.notifyDone();
    listenable.dispose();
    listenable = null;
    _value = null;
  }

  int get length => listenable.length;

  bool get hasListeners => listenable.hasListeners;

  bool get isClosed => listenable == null;

  LightSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    final subs = LightSubscription<T>(listenable)
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone);
    listenable.addSubscription(subs);
    return subs;
  }

  Stream<T> get stream => GetStreamTransformation(listenable);
}

class LightListenable<T> {
  List<LightSubscription<T>> _onData = <LightSubscription<T>>[];

  bool _isBusy = false;

  FutureOr<bool> removeSubscription(LightSubscription<T> subs) async {
    if (!_isBusy) {
      return _onData.remove(subs);
    } else {
      await Future.delayed(Duration.zero);
      return _onData.remove(subs);
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

  void notifyData(T data) {
    assert(!isDisposed, 'You cannot add data to a closed stream.');
    _isBusy = true;
    for (final item in _onData) {
      if (item.isPaused) {
        break;
      }
      item._data?.call(data);
    }
    _isBusy = false;
  }

  void notifyError(Object error, [StackTrace stackTrace]) {
    assert(!isDisposed, 'You cannot add errors to a closed stream.');
    _isBusy = true;
    for (final item in _onData) {
      if (item.isPaused) {
        break;
      }
      item._onError?.call(error, stackTrace);
      if (item.cancelOnError) {
        item.cancel?.call();
        item._onDone?.call();
      }
    }
    _isBusy = false;
  }

  void notifyDone() {
    assert(!isDisposed, 'You cannot close a closed stream.');
    _isBusy = true;
    for (final item in _onData) {
      if (item.isPaused) {
        break;
      }
      item._onDone?.call();
    }
    _isBusy = false;
  }

  void dispose() {
    _onData = null;
    _isBusy = null;
  }

  bool get isDisposed => _onData == null;
}

class LightSubscription<T> extends StreamSubscription<T> {
  final LightListenable<T> listener;

  LightSubscription(this.listener);

  bool cancelOnError = false;

  @override
  Future<void> cancel() {
    listener.removeSubscription(this);
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
  void pause([Future<void> resumeSignal]) => _isPaused = true;

  @override
  void resume() => _isPaused = false;

  @override
  bool get isPaused => _isPaused;

  @override
  Future<E> asFuture<E>([E futureValue]) => Future.value(futureValue);
}

class GetStreamTransformation<T> extends Stream<T> {
  final LightListenable<T> listenable;

  GetStreamTransformation(this.listenable);

  @override
  LightSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    final subs = LightSubscription<T>(listenable)
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone);
    listenable.addSubscription(subs);
    return subs;
  }
}
