import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../rx_core/rx_impl.dart';
import '../rx_core/rx_interface.dart';
import '../rx_typedefs/rx_typedefs.dart';

/// Create a list similar to `List<T>`
class RxList<E> implements List<E>, RxInterface<List<E>> {
  RxList([List<E> initial]) {
    _list = initial;
  }

  List<E> _list = <E>[];

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  bool get canUpdate {
    return _subscriptions.length > 0;
  }

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  StreamController<List<E>> subject = StreamController.broadcast();

  final Map<Stream<List<E>>, StreamSubscription> _subscriptions = {};

  void operator []=(int index, E val) {
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

  @override
  void addAll(Iterable<E> item) {
    _list.addAll(item);
    subject.add(_list);
  }

  /// Add [item] to [List<E>] only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Add [Iterable<E>] to [List<E>] only if [Iterable<E>] is not null.
  void addAllNonNull(Iterable<E> item) {
    if (item != null) addAll(item);
  }

  /// Add [item] to [List<E>] only if [condition] is true.
  void addIf(dynamic condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Adds [Iterable<E>] to [List<E>] only if [condition] is true.
  void addAllIf(dynamic condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  @override
  void insert(int index, E item) {
    _list.insert(index, item);
    subject.add(_list);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _list.insertAll(index, iterable);
    subject.add(_list);
  }

  @override
  int get length => value.length;

  /// Removes an item from the list.
  ///
  /// This is O(N) in the number of items in the list.
  ///
  /// Returns whether the item was present in the list.
  @override
  bool remove(Object item) {
    final hasRemoved = _list.remove(item);
    if (hasRemoved) {
      subject.add(_list);
    }
    return hasRemoved;
  }

  @override
  E removeAt(int index) {
    final item = _list.removeAt(index);
    subject.add(_list);
    return item;
  }

  @override
  E removeLast() {
    final item = _list.removeLast();
    subject.add(_list);
    return item;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    subject.add(_list);
  }

  @override
  void removeWhere(bool Function(E) test) {
    _list.removeWhere(test);
    subject.add(_list);
  }

  @override
  void clear() {
    _list.clear();
    subject.add(_list);
  }

  @override
  void sort([int compare(E a, E b)]) {
    _list.sort(compare);
    subject.add(_list);
  }

  @override
  void close() {
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

  void addListener(Stream<List<E>> rxGetX) {
    if (_subscriptions.containsKey(rxGetX)) {
      return;
    }
    _subscriptions[rxGetX] = rxGetX.listen(subject.add);
  }

  set value(List<E> val) {
    if (_list == val) return;
    _list = val;
    subject.add(_list);
  }

  Stream<List<E>> get stream => subject.stream;

  StreamSubscription<List<E>> listen(
    void Function(List<E>) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<List<E>> stream) => stream.listen((va) => value = va);

  @override
  E get first => value.first;

  @override
  E get last => value.last;

  @override
  bool any(bool Function(E) test) {
    return value.any(test);
  }

  @override
  Map<int, E> asMap() {
    return value.asMap();
  }

  @override
  List<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  bool contains(Object element) {
    return value.contains(element);
  }

  @override
  E elementAt(int index) {
    return value.elementAt(index);
  }

  @override
  bool every(bool Function(E) test) {
    return value.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) {
    return value.expand(f);
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _list.fillRange(start, end, fillValue);
    subject.add(_list);
  }

  @override
  E firstWhere(bool Function(E) test, {E Function() orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) {
    return value.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return value.followedBy(other);
  }

  @override
  void forEach(void Function(E) f) {
    value.forEach(f);
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return value.getRange(start, end);
  }

  @override
  int indexOf(E element, [int start = 0]) {
    return value.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(E) test, [int start = 0]) {
    return value.indexWhere(test, start);
  }

  @override
  String join([String separator = ""]) {
    return value.join(separator);
  }

  @override
  int lastIndexOf(E element, [int start]) {
    return value.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(E) test, [int start]) {
    return value.lastIndexWhere(test, start);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function() orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  set length(int newLength) {
    _list.length = newLength;
    subject.add(_list);
  }

  @override
  Iterable<T> map<T>(T Function(E) f) {
    return value.map(f);
  }

  @override
  E reduce(E Function(E, E) combine) {
    return value.reduce(combine);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _list.replaceRange(start, end, replacement);
    subject.add(_list);
  }

  @override
  void retainWhere(bool Function(E) test) {
    _list.retainWhere(test);
    subject.add(_list);
  }

  @override
  Iterable<E> get reversed => value.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    _list.setAll(index, iterable);
    subject.add(_list);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    subject.add(_list);
  }

  @override
  void shuffle([Random random]) {
    _list.shuffle(random);
    subject.add(_list);
  }

  @override
  E get single => value.single;

  @override
  E singleWhere(bool Function(E) test, {E Function() orElse}) {
    return value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return value.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E) test) {
    return value.skipWhile(test);
  }

  @override
  List<E> sublist(int start, [int end]) {
    return value.sublist(start, end);
  }

  @override
  Iterable<E> take(int count) {
    return value.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E) test) {
    return value.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return value.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  Iterable<E> where(bool Function(E) test) {
    return value.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return value.whereType<T>();
  }

  @override
  set first(E value) {
    _list.first = value;
    subject.add(_list);
  }

  @override
  set last(E value) {
    _list.last = value;
    subject.add(_list);
  }
}

extension ListExtension<E> on List<E> {
  RxList<E> get obs {
    if (this != null) {
      return RxList<E>(<E>[])..addAllNonNull(this);
    } else {
      return RxList<E>(null);
    }
  }
}
