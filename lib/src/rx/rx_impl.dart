import 'dart:async';
import 'rx_interface.dart';

class _RxImpl<T> implements RxInterface<T> {
  StreamController<T> subject = StreamController<T>.broadcast();
  Map<Stream<T>, StreamSubscription> _subscriptions = Map();

  T _value;
  T get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  String get string => value.toString();

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
  }

  addListener(Stream<T> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  set value(T val) {
    if (_value == val) return;
    _value = val;
    subject.add(_value);
  }

  Stream<T> get stream => subject.stream;

  StreamSubscription<T> listen(void Function(T) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<T> stream) => stream.listen((va) => value = va);
  Stream<R> map<R>(R mapper(T data)) => stream.map(mapper);
}

class StringX<String> extends _RxImpl<String> {
  StringX([String initial]) {
    _value = initial;
  }
}

class IntX<int> extends _RxImpl<int> {
  IntX([int initial]) {
    _value = initial;
  }
}

class MapX<K, V> extends RxInterface implements Map<K, V> {
  MapX([Map<K, V> initial]) {
    _value = initial;
  }

  StreamController subject = StreamController<Map<K, V>>.broadcast();
  Map<Stream<Map<K, V>>, StreamSubscription> _subscriptions = Map();

  Map<K, V> _value;
  Map<K, V> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  String get string => value.toString();

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
  }

  addListener(Stream rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  set value(Map<K, V> val) {
    if (_value == val) return;
    _value = val;
    subject.add(_value);
  }

  Stream<Map<K, V>> get stream => subject.stream;

  StreamSubscription<Map<K, V>> listen(void Function(Map<K, V>) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<Map<K, V>> stream) =>
      stream.listen((va) => value = va);

  void add(K key, V value) {
    _value[key] = value;
    subject.add(_value);
  }

  void addIf(/* bool | Condition */ condition, K key, V value) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) {
      _value[key] = value;
      subject.add(_value);
    }
  }

  void addAllIf(/* bool | Condition */ condition, Map<K, V> values) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(values);
  }

  @override
  V operator [](Object key) {
    return value[key];
  }

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    subject.add(_value);
  }

  @override
  void addAll(Map<K, V> other) {
    _value.addAll(other);
    subject.add(_value);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    _value.addEntries(entries);
    subject.add(_value);
  }

  @override
  void clear() {
    _value.clear();
    subject.add(_value);
  }

  @override
  Map<K2, V2> cast<K2, V2>() => _value.cast<K2, V2>();

  @override
  bool containsKey(Object key) => _value.containsKey(key);

  @override
  bool containsValue(Object value) => _value.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _value.entries;

  @override
  void forEach(void Function(K, V) f) {
    _value.forEach(f);
  }

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterable<K> get keys => _value.keys;

  @override
  int get length => value.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) =>
      value.map(transform);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final val = _value.putIfAbsent(key, ifAbsent);
    subject.add(_value);
    return val;
  }

  @override
  V remove(Object key) {
    final val = _value.remove(key);
    subject.add(_value);
    return val;
  }

  @override
  void removeWhere(bool Function(K, V) test) {
    _value.removeWhere(test);
    subject.add(_value);
  }

  @override
  Iterable<V> get values => value.values;

  @override
  String toString() => _value.toString();

  @override
  V update(K key, V Function(V) update, {V Function() ifAbsent}) {
    final val = _value.update(key, update, ifAbsent: ifAbsent);
    subject.add(_value);
    return val;
  }

  @override
  void updateAll(V Function(K, V) update) {
    _value.updateAll(update);
    subject.add(_value);
  }
}

/// Create a list similar to `List<T>`
class ListX<E> extends Iterable<E> implements RxInterface<E> {
  ListX([List<E> initial]) {
    _list = initial;
  }

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  StreamController<E> subject = StreamController<E>.broadcast();
  Map<Stream<E>, StreamSubscription> _subscriptions = Map();

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
    subject.add(val);
  }

  E operator [](int index) {
    return value[index];
  }

  void add(E item) {
    _list.add(item);
    subject.add(item);
  }

  void addAll(Iterable<E> item) {
    _list.addAll(item);
    subject.add(null);
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
    subject.add(item);
  }

  void insertAll(int index, Iterable<E> iterable) {
    _list.insertAll(index, iterable);
    subject.add(iterable.last);
  }

  int get length => value.length;

  /// Removes an item from the list.
  ///
  /// This is O(N) in the number of items in the list.
  ///
  /// Returns whether the item was present in the list.
  bool remove(Object item) {
    bool hasRemoved = _list.remove(item);
    if (hasRemoved) {
      subject.add(item);
    }
    return hasRemoved;
  }

  E removeAt(int index) {
    E item = _list.removeAt(index);
    subject.add(item);
    return item;
  }

  E removeLast() {
    E item = _list.removeLast();
    subject.add(item);
    return item;
  }

  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    subject.add(null);
  }

  void removeWhere(bool Function(E) test) {
    _list.removeWhere(test);
    subject.add(null);
  }

  void clear() {
    _list.clear();
    subject.add(null);
  }

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
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

  List<E> _value;
  List<E> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  String get string => value.toString();

  addListener(Stream<E> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  set value(Iterable<E> val) {
    if (_value == val) return;
    _value = val;
    subject.add(null);
  }

  Stream<E> get stream => subject.stream;

  StreamSubscription<E> listen(void Function(E) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<Iterable<E>> stream) =>
      stream.listen((va) => value = va);

  List<E> _list = <E>[];
}

RxInterface getObs;

typedef bool Condition();

typedef E ChildrenListComposer<S, E>(S value);

class BoolX<bool> extends _RxImpl<bool> {
  BoolX([bool initial]) {
    _value = initial;
  }
}

class DoubleX<double> extends _RxImpl<double> {
  DoubleX([double initial]) {
    _value = initial;
  }
}

class NumX<num> extends _RxImpl<num> {
  NumX([num initial]) {
    _value = initial;
  }
}

class Rx<T> extends _RxImpl<T> {
  Rx([T initial]) {
    _value = initial;
  }
}

extension StringExtension on String {
  StringX<String> get obs => StringX(this);
}

extension IntExtension on int {
  IntX<int> get obs => IntX(this);
}

extension DoubleExtension on double {
  DoubleX<double> get obs => DoubleX(this);
}

extension BoolExtension on bool {
  BoolX<bool> get obs => BoolX(this);
}

extension MapExtension<K, V> on Map<K, V> {
  MapX<K, V> get obs {
    if (this != null)
      return MapX<K, V>({})..addAll(this);
    else
      return MapX<K, V>(null);
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

extension ObjectExtension on Object {
  Rx<Object> get obs => Rx(this);
}
