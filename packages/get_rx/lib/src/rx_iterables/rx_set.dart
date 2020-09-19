import 'dart:async';
import 'dart:collection';
import 'package:meta/meta.dart';

import '../rx_core/rx_impl.dart';
import '../rx_core/rx_interface.dart';
import '../rx_typedefs/rx_typedefs.dart';

class RxSet<E> implements Set<E>, RxInterface<Set<E>> {
  RxSet([Set<E> initial]) {
    if (initial != null) _set = initial;
  }

  Set<E> _set = <E>{};

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  bool get canUpdate {
    return _subscriptions.length > 0;
  }

  @override
  bool get isNotEmpty => value.isNotEmpty;

  StreamController<Set<E>> subject = StreamController<Set<E>>.broadcast();
  final _subscriptions = HashMap<Stream<Set<E>>, StreamSubscription>();

  /// Adds [item] only if [condition] resolves to true.
  void addIf(dynamic condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Adds all [items] only if [condition] resolves to true.
  void addAllIf(dynamic condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  void refresh() {
    subject.add(_set);
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  RxSet<E> operator +(Set<E> val) {
    addAll(val);
    refresh();
    return this;
  }

  @override
  bool add(E value) {
    final val = _set.add(value);
    refresh();
    return val;
  }

  @override
  void addAll(Iterable<E> item) {
    _set.addAll(item);
    refresh();
  }

  /// Adds only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Adds only if [item] is not null.
  void addAllNonNull(Iterable<E> item) {
    if (item != null) addAll(item);
  }

  int get length => value.length;

  /// Removes an item from the list.
  ///
  /// This is O(N) in the number of items in the list.
  ///
  /// Returns whether the item was present in the list.
  bool remove(Object item) {
    var hasRemoved = _set.remove(item);
    if (hasRemoved) {
      refresh();
    }
    return hasRemoved;
  }

  void removeWhere(bool Function(E) test) {
    _set.removeWhere(test);
    refresh();
  }

  void clear() {
    _set.clear();
    refresh();
  }

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
    refresh();
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    clear();
    addAll(items);
  }

  @protected
  Set<E> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _set;
  }

  String get string => value.toString();

  void addListener(Stream<Set<E>> rxGetX) {
    if (_subscriptions.containsKey(rxGetX)) {
      return;
    }
    _subscriptions[rxGetX] = rxGetX.listen((data) {
      subject.add(data);
    });
  }

  set value(Set<E> val) {
    if (_set == val) return;
    _set = val;
    refresh();
  }

  Stream<Set<E>> get stream => subject.stream;

  StreamSubscription<Set<E>> listen(void Function(Set<E>) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  /// Binds an existing [Stream<Set>] to this [RxSet].
  /// You can bind multiple sources to update the value.
  /// Closing the subscription will happen automatically when the observer
  /// Widget ([GetX] or [Obx]) gets unmounted from the Widget tree.
  void bindStream(Stream<Set<E>> stream) {
    _subscriptions[stream] = stream.listen((va) => value = va);
  }

  @override
  E get first => value.first;

  @override
  E get last => value.last;

  @override
  bool any(bool Function(E) test) {
    return value.any(test);
  }

  @override
  Set<R> cast<R>() {
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
  String join([String separator = ""]) {
    return value.join(separator);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function() orElse}) {
    return value.lastWhere(test, orElse: orElse);
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
  bool containsAll(Iterable<Object> other) {
    return value.containsAll(other);
  }

  @override
  Set<E> difference(Set<Object> other) {
    return value.difference(other);
  }

  @override
  Set<E> intersection(Set<Object> other) {
    return value.intersection(other);
  }

  @override
  E lookup(Object object) {
    return value.lookup(object);
  }

  @override
  void removeAll(Iterable<Object> elements) {
    _set.removeAll(elements);
    refresh();
  }

  @override
  void retainAll(Iterable<Object> elements) {
    _set.retainAll(elements);
    refresh();
  }

  @override
  void retainWhere(bool Function(E) E) {
    _set.retainWhere(E);
    refresh();
  }

  @override
  Set<E> union(Set<E> other) {
    return value.union(other);
  }
}

extension SetExtension<E> on Set<E> {
  RxSet<E> get obs {
    if (this != null) {
      return RxSet<E>(<E>{})..addAllNonNull(this);
    } else {
      return RxSet<E>(null);
    }
  }
}
