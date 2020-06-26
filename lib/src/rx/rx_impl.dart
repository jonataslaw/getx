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

  bool firstRebuild = true;

  set value(T val) {
    if (_value == val && !firstRebuild) return;
    firstRebuild = false;
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

class RxString<String> extends _RxImpl<String> {
  RxString([String initial]) {
    _value = initial;
  }
}

class RxInt<int> extends _RxImpl<int> {
  RxInt([int initial]) {
    _value = initial;
  }
}

class RxMap<K, V> extends RxInterface implements Map<K, V> {
  RxMap([Map<K, V> initial]) {
    _value = initial;
  }

  @override
  StreamController subject = StreamController<Map<K, V>>.broadcast();
  final Map<Stream<Map<K, V>>, StreamSubscription> _subscriptions = {};

  Map<K, V> _value;
  Map<K, V> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  String get string => value.toString();

  @override
  void close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
  }

  @override
  void addListener(Stream rxGetx) {
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

  void addIf(condition, K key, V value) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) {
      _value[key] = value;
      subject.add(_value);
    }
  }

  void addAllIf(condition, Map<K, V> values) {
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
class RxList<E> extends Iterable<E> implements RxInterface<E> {
  RxList([List<E> initial]) {
    _list = initial;
  }

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

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

  void sort([int compare(E a, E b)]) {
    _list.sort();
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

  List<E> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _list;
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
    if (_list == val) return;
    _list = val;
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

class RxBool<bool> extends _RxImpl<bool> {
  RxBool([bool initial]) {
    _value = initial;
  }
}

class RxDouble<double> extends _RxImpl<double> {
  RxDouble([double initial]) {
    _value = initial;
  }
}

class RxNum<num> extends _RxImpl<num> {
  RxNum([num initial]) {
    _value = initial;
  }
}

class Rx<T> extends _RxImpl<T> {
  Rx([T initial]) {
    _value = initial;
  }
}

extension StringExtension on String {
  RxString<String> get obs => RxString(this);
}

extension IntExtension on int {
  RxInt<int> get obs => RxInt(this);
}

extension DoubleExtension on double {
  RxDouble<double> get obs => RxDouble(this);
}

extension BoolExtension on bool {
  RxBool<bool> get obs => RxBool(this);
}

extension MapExtension<K, V> on Map<K, V> {
  RxMap<K, V> get obs {
    if (this != null)
      return RxMap<K, V>({})..addAll(this);
    else
      return RxMap<K, V>(null);
  }
}

extension ListExtension<E> on List<E> {
  RxList<E> get obs {
    if (this != null)
      return RxList<E>([])..addAllNonNull(this);
    else
      return RxList<E>(null);
  }
}

extension ObjectExtension on Object {
  Rx<Object> get obs => Rx(this);
}
