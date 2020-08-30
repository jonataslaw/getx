import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

import 'rx_impl.dart';
import 'rx_interface.dart';
import 'rx_typedefs.dart';

/// Create a list similar to `List<T>`
class RxList<E> implements List<E>, RxInterface<List<E>> {
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
  RxList<E> operator +(Iterable<E> val) {
    addAll(val);
    subject.add(_list);
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

  @protected
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

  @override
  E get first => _list.first;

  @override
  E get last => _list.last;

  @override
  bool any(bool Function(E) test) {
    return _list.any(test);
  }

  @override
  Map<int, E> asMap() {
    return _list.asMap();
  }

  @override
  List<R> cast<R>() {
    return _list.cast<R>();
  }

  @override
  bool contains(Object element) {
    return _list.contains(element);
  }

  @override
  E elementAt(int index) {
    return _list.elementAt(index);
  }

  @override
  bool every(bool Function(E) test) {
    return _list.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) {
    return _list.expand(f);
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _list.fillRange(start, end, fillValue);
  }

  @override
  E firstWhere(bool Function(E) test, {E Function() orElse}) {
    return _list.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) {
    return _list.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return _list.followedBy(other);
  }

  @override
  void forEach(void Function(E) f) {
    _list.forEach(f);
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return _list.getRange(start, end);
  }

  @override
  int indexOf(E element, [int start = 0]) {
    return _list.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(E) test, [int start = 0]) {
    return _list.indexWhere(test, start);
  }

  @override
  String join([String separator = ""]) {
    return _list.join(separator);
  }

  @override
  int lastIndexOf(E element, [int start]) {
    return _list.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(E) test, [int start]) {
    return _list.lastIndexWhere(test, start);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function() orElse}) {
    return _list.lastWhere(test, orElse: orElse);
  }

  @override
  set length(int newLength) {
    _list.length = newLength;
  }

  @override
  Iterable<T> map<T>(T Function(E) f) {
    return _list.map(f);
  }

  @override
  E reduce(E Function(E, E) combine) {
    return _list.reduce(combine);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _list.replaceRange(start, end, replacement);
  }

  @override
  void retainWhere(bool Function(E) test) {
    _list.retainWhere(test);
  }

  @override
  Iterable<E> get reversed => _list.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    _list.setAll(index, iterable);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
  }

  @override
  void shuffle([Random random]) {
    _list.shuffle(random);
  }

  @override
  E get single => _list.single;

  @override
  E singleWhere(bool Function(E) test, {E Function() orElse}) {
    return _list.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return _list.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E) test) {
    return _list.skipWhile(test);
  }

  @override
  List<E> sublist(int start, [int end]) {
    return _list.sublist(start, end);
  }

  @override
  Iterable<E> take(int count) {
    return _list.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E) test) {
    return _list.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return _list.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return _list.toSet();
  }

  @override
  Iterable<E> where(bool Function(E) test) {
    return _list.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return _list.whereType<T>();
  }

  @override
  set first(E value) {
    _list.first = value;
  }

  @override
  set last(E value) {
    _list.last = value;
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
