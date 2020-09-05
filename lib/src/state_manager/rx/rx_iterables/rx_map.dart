import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../get.dart';
import '../rx_core/rx_interface.dart';
import '../rx_typedefs/rx_typedefs.dart';

class RxMap<K, V> implements RxInterface<Map<K, V>>, Map<K, V> {
  RxMap([Map<K, V> initial]) {
    _value = initial;
  }

  @override
  StreamController<Map<K, V>> subject = StreamController<Map<K, V>>.broadcast();
  final Map<Stream<Map<K, V>>, StreamSubscription> _subscriptions = {};

  Map<K, V> _value;

  @protected
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
  void addListener(Stream<Map<K, V>> rxGetX) {
    if (_subscriptions.containsKey(rxGetX)) {
      return;
    }
    _subscriptions[rxGetX] = rxGetX.listen((data) {
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

  void addIf(dynamic condition, K key, V value) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) {
      _value[key] = value;
      subject.add(_value);
    }
  }

  void addAllIf(dynamic condition, Map<K, V> values) {
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
  Map<K2, V2> cast<K2, V2>() => value.cast<K2, V2>();

  @override
  bool containsKey(Object key) => value.containsKey(key);

  @override
  bool containsValue(Object value) => _value.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => value.entries;

  @override
  void forEach(void Function(K, V) f) {
    value.forEach(f);
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterable<K> get keys => value.keys;

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

extension MapExtension<K, V> on Map<K, V> {
  RxMap<K, V> get obs {
    if (this != null) {
      return RxMap<K, V>(<K, V>{})..addAll(this);
    } else {
      return RxMap<K, V>(null);
    }
  }
}
