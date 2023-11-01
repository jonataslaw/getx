part of rx_types;

class RxMap<K, V> extends GetListenable<Map<K, V>>
    with MapMixin<K, V>, RxObjectMixin<Map<K, V>> {
  RxMap([super.initial = const {}]);

  factory RxMap.from(final Map<K, V> other) {
    return RxMap(Map.from(other));
  }

  /// Creates a [LinkedHashMap] with the same keys and values as [other].
  factory RxMap.of(final Map<K, V> other) {
    return RxMap(Map.of(other));
  }

  ///Creates an unmodifiable hash based map containing the entries of [other].
  factory RxMap.unmodifiable(final Map<dynamic, dynamic> other) {
    return RxMap(Map.unmodifiable(other));
  }

  /// Creates an identity map with the default implementation, [LinkedHashMap].
  factory RxMap.identity() {
    return RxMap(Map.identity());
  }

  @override
  V? operator [](final Object? key) {
    return value[key as K];
  }

  @override
  void operator []=(final K key, final V value) {
    this.value[key] = value;
    refresh();
  }

  @override
  void clear() {
    value.clear();
    refresh();
  }

  @override
  Iterable<K> get keys => value.keys;

  @override
  V? remove(final Object? key) {
    final val = value.remove(key);
    refresh();
    return val;
  }

  // @override
  // @protected
  // Map<K, V> get value {
  //   return subject.value;
  //   // RxInterface.proxy?.addListener(subject);
  //   // return _value;
  // }
}

extension MapExtension<K, V> on Map<K, V> {
  RxMap<K, V> get obs {
    return RxMap<K, V>(this);
  }

  void addIf(dynamic condition, final K key, final V value) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) {
      this[key] = value;
    }
  }

  void addAllIf(dynamic condition, final Map<K, V> values) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(values);
  }

  void assign(final K key, final V val) {
    if (this is RxMap) {
      final map = (this as RxMap);
      // map._value;
      map.value.clear();
      this[key] = val;
    } else {
      clear();
      this[key] = val;
    }
  }

  void assignAll(final Map<K, V> val) {
    if (val is RxMap && this is RxMap) {
      if ((val as RxMap).value == (this as RxMap).value) return;
    }
    if (this is RxMap) {
      final map = (this as RxMap);
      if (map.value == val) return;
      map.value = val;
      // ignore: invalid_use_of_protected_member
      map.refresh();
    } else {
      if (this == val) return;
      clear();
      addAll(val);
    }
  }
}
