import 'dart:async';
import 'rx_callbacks.dart';
import 'rx_interface.dart';
import 'rx_model.dart';

class _RxImpl<T> implements RxInterface<T> {
  StreamController<Change<T>> subject = StreamController<Change<T>>.broadcast();
  StreamController<Change<T>> _changeCtl = StreamController<Change<T>>();
  Map<Stream<Change<T>>, StreamSubscription> _subscriptions = Map();

  T _value;
  T get v {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  T get value => v;
  set value(T va) => v = va;

  String get string => v.toString();

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    _changeCtl.close();
  }

  addListener(Stream<Change<T>> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }

    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  set v(T val) {
    if (_value == val) return;
    T old = _value;
    _value = val;
    subject.add(Change<T>($new: val, $old: old, batch: _cb));
  }

  int _cb = 0;

  _RxImpl([T initial]) : _value = initial {
    _onChange = subject.stream.asBroadcastStream();
  }

  void setCast(dynamic /* T */ val) => v = val;

  Stream<Change<T>> _onChange;

  Stream<Change<T>> get onChange {
    _cb++;

    _changeCtl.add(Change<T>($new: v, $old: null, batch: _cb));
    _changeCtl.addStream(_onChange.skipWhile((v) => v.batch < _cb));
    return _changeCtl.stream.asBroadcastStream();
  }

  Stream<T> get stream => onChange.map((c) => c.$new);

  void bind(RxInterface<T> reactive) {
    v = reactive.v;
    reactive.stream.listen((va) => v = va);
  }

  void bindStream(Stream<T> stream) => stream.listen((va) => v = va);

  void bindOrSet(/* T | Stream<T> | Reactive<T> */ other) {
    if (other is RxInterface<T>) {
      bind(other);
    } else if (other is Stream<T>) {
      bindStream(other.cast<T>());
    } else {
      v = other;
    }
  }

  StreamSubscription<T> listen(ValueCallback<T> callback) =>
      stream.listen(callback);

  Stream<R> map<R>(R mapper(T data)) => stream.map(mapper);
}

class StringX<String> extends _RxImpl<String> {
  StringX([String initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class IntX<int> extends _RxImpl<int> {
  IntX([int initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class MapX<Map> extends _RxImpl<Map> {
  MapX([Map initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

/// Create a list similar to `List<T>`
class ListX<E> extends Iterable<E> implements RxInterface<E> {
  ListX([List<E> initial]) {
    _list = initial;
    _onChange = subject.stream.asBroadcastStream();
  }

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  Map<Stream<Change<E>>, StreamSubscription> _subscriptions = Map();

  // StreamSubscription _changectl = StreamSubscription();

  StreamController<Change<E>> _changeCtl =
      StreamController<Change<E>>.broadcast();

  @override
  StreamController<Change<E>> subject = StreamController<Change<E>>.broadcast();

  /// Adds [item] only if [condition] resolves to true.
  void addIf(condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Adds all [items] only if [condition] resolves to true.
  void addAllIf(condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  operator []=(int index, E val) {
    _list[index] = val;
    subject.add(Change<E>.set($new: val, pos: index));
  }

  E operator [](int index) {
    return value[index];
  }

  void add(E item) {
    _list.add(item);
    subject.add(Change<E>.insert($new: item, pos: _list.length - 1));
  }

  void addAll(List<E> item) {
    _list.addAll(item);
    subject.add(Change<E>.insert($new: _list, pos: _list.length - 1));
  }

  /// Adds only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Adds only if [item] is not null.
  void addAllNonNull(Iterable<E> item) {
    if (item != null) addAll(item);
  }

  void insert(int index, E item) {
    _list.insert(index, item);
    subject.add(Change<E>.insert($new: item, pos: index));
  }

  void insertAll(int index, Iterable<E> iterable) {
    _list.insertAll(index, iterable);
    subject.add(Change<E>.insert($new: iterable.last, pos: index));
  }

  int get length => value.length;

  /// Removes an item from the list.
  ///
  /// This is O(N) in the number of items in the list.
  ///
  /// Returns whether the item was present in the list.
  bool remove(Object item) {
    int pos = _list.indexOf(item);
    bool hasRemoved = _list.remove(item);
    if (hasRemoved) {
      subject.add(Change<E>.remove($new: item, pos: pos));
    }
    return hasRemoved;
  }

  E removeAt(int index) {
    E item = _list.removeAt(index);
    subject.add(Change<E>.remove($new: item, pos: index));
    return item;
  }

  E removeLast() {
    int pos = _list.indexOf(_list.last);
    E item = _list.removeLast();
    subject.add(Change<E>.remove($new: item, pos: pos));
    return item;
  }

  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    subject.add(Change<E>.remove($new: null, pos: null));
  }

  void removeWhere(bool Function(E) test) {
    _list.removeWhere(test);
    subject.add(Change<E>.remove($new: null, pos: null));
  }

  void clear() {
    _list.clear();
    subject.add(Change<E>.clear());
  }

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
    _changeCtl.close();
  }

  /// Replaces all existing items of this list with [item]
  void assign(E item) {
    clear();
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    clear();
    addAll(items);
  }

  /// A stream of record of changes to this list
  Stream<Change<E>> get onChange {
    final now = DateTime.now();

    _onChange.skipWhile((m) => m.time.isBefore(now));
    return _changeCtl.stream.asBroadcastStream();
  }

  Stream<Change<E>> _onChange;

  addListener(Stream<Change<E>> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  List<E> get value => v as List<E>;

  set value(List<E> va) => assignAll(va);

  @override
  get v {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _list;
  }

  set v(E val) {
    assign(val);
  }

  @override
  Stream<E> get stream => onChange.map((c) => c.$new);

  @override
  void bind(RxInterface<E> reactive) {
    v = reactive.v;
    reactive.stream.listen((va) => v = va);
  }

  void bindStream(Stream<E> stream) => stream.listen((va) => v = va);

  @override
  void bindOrSet(/* T | Stream<T> or Rx<T> */ other) {
    if (other is RxInterface<E>) {
      bind(other);
    } else if (other is Stream<E>) {
      bindStream(other.cast<E>());
    } else {
      v = other;
    }
  }

  @override
  StreamSubscription<E> listen(ValueCallback<E> callback) =>
      stream.listen(callback);

  @override
  void setCast(dynamic val) => v = val;

  List<E> _list = <E>[];
}

RxInterface getObs;

typedef bool Condition();

typedef E ChildrenListComposer<S, E>(S value);

class BoolX<bool> extends _RxImpl<bool> {
  BoolX([bool initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class DoubleX<double> extends _RxImpl<double> {
  DoubleX([double initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class NumX<num> extends _RxImpl<num> {
  NumX([num initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class Rx<T> extends _RxImpl<T> {
  Rx([T initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

extension StringExtension on String {
  StringX<String> get obs {
    if (this != null)
      return StringX(this);
    else
      return StringX(null);
  }
}

extension IntExtension on int {
  IntX<int> get obs {
    if (this != null)
      return IntX(this);
    else
      return IntX(null);
  }
}

extension DoubleExtension on double {
  DoubleX<double> get obs {
    if (this != null)
      return DoubleX(this);
    else
      return DoubleX(null);
  }
}

extension MapExtension on Map {
  MapX<Map> get obs {
    if (this != null)
      return MapX(this);
    else
      return MapX(null);
  }
}

extension ListExtension<E> on List<E> {
  ListX<E> get obs {
    if (this != null)
      return ListX<E>([])..addAllNonNull(this);
    else
      return ListX<E>(null);
  }
}

extension BoolExtension on bool {
  BoolX<bool> get obs {
    if (this != null)
      return BoolX(this);
    else
      return BoolX(null);
  }
}

extension ObjectExtension on Object {
  Rx<Object> get obs {
    if (this != null)
      return Rx(this);
    else
      return Rx(null);
  }
}
