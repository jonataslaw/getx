import 'dart:async';
import 'dart:collection';

import 'rx_interface.dart';

RxInterface getObs;

typedef bool Condition();

class _RxImpl<T> implements RxInterface<T> {
  StreamController<T> subject = StreamController<T>.broadcast();
  HashMap<Stream<T>, StreamSubscription> _subscriptions =
      HashMap<Stream<T>, StreamSubscription>();

  T _value;

  /// Common to all Types [T], this operator overloading is using for
  /// assignment, same as rx.value
  ///
  /// Example:
  /// ```
  /// var counter = 0.obs ;
  /// counter >>= 3; // same as counter.value=3;
  /// print(counter); // calls .toString() now
  /// ```
  ///
  /// WARNING: still WIP, needs testing!
  _RxImpl<T> operator >>(T val) {
    subject.add(value = val);
    return this;
  }

  bool get canUpdate => _subscriptions.isNotEmpty;

  /// Makes this Rx looks like a function so you can update a new
  /// value using [rx(someOtherValue)]. Practical to assign the Rx directly
  /// to some Widget that has a signature ::onChange( value )
  ///
  /// Example:
  /// ```
  /// final myText = 'GetX rocks!'.obs;
  ///
  /// // in your Constructor, just to check it works :P
  /// ever( myText, print ) ;
  ///
  /// // in your build(BuildContext) {
  /// TextField(
  //    onChanged: myText,
  //  ),
  ///```
  T call([T v]) {
    if (v != null) this.value = v;
    return this.value;
  }

  /// Makes a direct update of [value] adding it to the Stream
  /// useful when you make use of Rx for custom Types to referesh your UI.
  ///
  /// Sample:
  /// ```
  ///  class Person {
  ///     String name, last;
  ///     int age;
  ///     Person({this.name, this.last, this.age});
  ///     @override
  ///     String toString() => '$name $last, $age years old';
  ///  }
  ///
  /// final person = Person(name: 'John', last: 'Doe', age: 18).obs;
  /// person.value.name = 'Roi';
  /// person.refresh();
  /// print( person );
  /// ```
  void refresh() {
    subject.add(value);
  }

  /// Uses a callback to update [value] internally, similar to [refresh], but provides
  /// the current value as the argument.
  /// Makes sense for custom Rx types (like Models).
  ///
  /// Sample:
  /// ```
  ///  class Person {
  ///     String name, last;
  ///     int age;
  ///     Person({this.name, this.last, this.age});
  ///     @override
  ///     String toString() => '$name $last, $age years old';
  ///  }
  ///
  /// final person = Person(name: 'John', last: 'Doe', age: 18).obs;
  /// person.update((person) {
  ///   person.name = 'Roi';
  /// });
  /// print( person );
  /// ```
  void update(void fn(T value)) {
    fn(value);
    subject.add(value);
  }

  String get string => value.toString();

  @override
  String toString() => value.toString();

  /// This equality override works for _RxImpl instances and the internal values.
  @override
  bool operator ==(dynamic o) {
    // Todo, find a common implementation for the hashCode of different Types.
    if (o is T) return _value == o;
    if (o is _RxImpl<T>) return _value == o.value;
    return false;
  }

  @override
  int get hashCode => _value.hashCode;

  void close() {
    _subscriptions.forEach((observable, subscription) => subscription.cancel());
    _subscriptions.clear();
    subject.close();
  }

  void addListener(Stream<T> rxGetx) {
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

  T get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  Stream<T> get stream => subject.stream;

  StreamSubscription<T> listen(void Function(T) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<T> stream) => stream.listen((va) => value = va);

  Stream<R> map<R>(R mapper(T data)) => stream.map(mapper);
}

class RxMap<K, V> extends RxInterface<Map<K, V>> implements Map<K, V> {
  RxMap([Map<K, V> initial]) {
    _value = initial;
  }

  @override
  StreamController<Map<K, V>> subject = StreamController<Map<K, V>>.broadcast();
  final Map<Stream<Map<K, V>>, StreamSubscription> _subscriptions = {};

  Map<K, V> _value;
  Map<K, V> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  String get string => value.toString();

  bool get canUpdate {
    return _subscriptions.length > 0;
  }

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
class RxList<E> extends Iterable<E> implements RxInterface<List<E>> {
  RxList([List<E> initial]) {
    _list = initial;
  }

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  bool get canUpdate {
    return _subscriptions.length > 0;
  }

  @override
  bool get isNotEmpty => value.isNotEmpty;

  StreamController<List<E>> subject = StreamController<List<E>>.broadcast();
  Map<Stream<List<E>>, StreamSubscription> _subscriptions = Map();

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
    subject.add(_list);
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  RxList<E> operator +(val) {
    if (val is Iterable)
      subject.add(_list..addAll(val));
    else
      subject.add(_list..add(val));
    return this;
  }

  E operator [](int index) {
    return value[index];
  }

  void add(E item) {
    _list.add(item);
    subject.add(_list);
  }

  void addAll(Iterable<E> item) {
    _list.addAll(item);
    subject.add(_list);
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
    subject.add(_list);
  }

  void insertAll(int index, Iterable<E> iterable) {
    _list.insertAll(index, iterable);
    subject.add(_list);
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
      subject.add(_list);
    }
    return hasRemoved;
  }

  E removeAt(int index) {
    E item = _list.removeAt(index);
    subject.add(_list);
    return item;
  }

  E removeLast() {
    E item = _list.removeLast();
    subject.add(_list);
    return item;
  }

  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    subject.add(_list);
  }

  void removeWhere(bool Function(E) test) {
    _list.removeWhere(test);
    subject.add(_list);
  }

  void clear() {
    _list.clear();
    subject.add(_list);
  }

  void sort([int compare(E a, E b)]) {
    _list.sort();
    subject.add(_list);
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

  void update(void fn(Iterable<E> value)) {
    fn(value);
    subject.add(_list);
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

  addListener(Stream<List<E>> rxGetx) {
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
    subject.add(_list);
  }

  Stream<List<E>> get stream => subject.stream;

  StreamSubscription<List<E>> listen(void Function(List<E>) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<Iterable<E>> stream) =>
      stream.listen((va) => value = va);

  List<E> _list = <E>[];
}

class RxBool extends _RxImpl<bool> {
  RxBool([bool initial]) {
    _value = initial;
  }
}

class RxDouble extends _RxImpl<double> {
  RxDouble([double initial]) {
    _value = initial;
  }

  RxDouble operator +(double val) {
    subject.add(value += val);
    return this;
  }

  RxDouble operator -(double val) {
    subject.add(value -= val);
    return this;
  }

  RxDouble operator /(double val) {
    subject.add(value /= val);
    return this;
  }

  RxDouble operator *(double val) {
    subject.add(value *= val);
    return this;
  }
}

class RxNum extends _RxImpl<num> {
  RxNum([num initial]) {
    _value = initial;
  }

  RxNum operator >>(num val) {
    subject.add(value = val);
    return this;
  }

  RxNum operator +(num val) {
    subject.add(value += val);
    return this;
  }

  RxNum operator -(num val) {
    subject.add(value -= val);
    return this;
  }

  RxNum operator /(num val) {
    subject.add(value /= val);
    return this;
  }

  RxNum operator *(num val) {
    subject.add(value *= val);
    return this;
  }
}

class RxString extends _RxImpl<String> {
  RxString([String initial]) {
    _value = initial;
  }

  RxString operator >>(String val) {
    subject.add(value = val);
    return this;
  }

  RxString operator +(String val) {
    subject.add(value += val);
    return this;
  }

  RxString operator *(int val) {
    subject.add(value *= val);
    return this;
  }
}

class RxInt extends _RxImpl<int> {
  RxInt([int initial]) {
    _value = initial;
  }

  RxInt operator >>(int val) {
    subject.add(value = val);
    return this;
  }

  RxInt operator +(int val) {
    subject.add(value += val);
    return this;
  }

  RxInt operator -(int val) {
    subject.add(value -= val);
    return this;
  }

  RxInt operator /(int val) {
    subject.add(value ~/= val);
    return this;
  }

  RxInt operator *(int val) {
    subject.add(value *= val);
    return this;
  }
}

class Rx<T> extends _RxImpl<T> {
  Rx([T initial]) {
    _value = initial;
  }
}

extension StringExtension on String {
  RxString get obs => RxString(this);
}

extension IntExtension on int {
  RxInt get obs => RxInt(this);
}

extension DoubleExtension on double {
  RxDouble get obs => RxDouble(this);
}

extension BoolExtension on bool {
  RxBool get obs => RxBool(this);
}

extension MapExtension<K, V> on Map<K, V> {
  RxMap<K, V> get obs {
    if (this != null)
      return RxMap<K, V>(<K, V>{})..addAll(this);
    else
      return RxMap<K, V>(null);
  }
}

extension ListExtension<E> on List<E> {
  RxList<E> get obs {
    if (this != null)
      return RxList<E>(<E>[])..addAllNonNull(this);
    else
      return RxList<E>(null);
  }
}

extension RxT<T> on T {
  Rx<T> get obs => Rx<T>(this);
}
