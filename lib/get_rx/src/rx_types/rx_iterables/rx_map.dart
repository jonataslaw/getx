part of rx_types;

class RxMap<K, V> extends MapMixin<K, V>
    with NotifyManager<Map<K, V>>, RxObjectMixin<Map<K, V>>
    implements RxInterface<Map<K, V>> {
  RxMap([Map<K, V> initial = const {}]) {
    if (initial != null) {
      _value = Map.from(initial);
    }
  }

  factory RxMap.from(Map<K, V> other) {
    return RxMap(Map.from(other));
  }

  /// Creates a [LinkedHashMap] with the same keys and values as [other].
  factory RxMap.of(Map<K, V> other) {
    return RxMap(Map.of(other));
  }

  ///Creates an unmodifiable hash based map containing the entries of [other].
  factory RxMap.unmodifiable(Map<dynamic, dynamic> other) {
    return RxMap(Map.unmodifiable(other));
  }

  /// Creates an identity map with the default implementation, [LinkedHashMap].
  factory RxMap.identity() {
    return RxMap(Map.identity());
  }

  @override
  V operator [](Object key) {
    return value[key];
  }

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    refresh();
  }

  @override
  void clear() {
    _value.clear();
    refresh();
  }

  @override
  Iterable<K> get keys => value.keys;

  @override
  V remove(Object key) {
    final val = _value.remove(key);
    refresh();
    return val;
  }

  @override
  @protected
  Map<K, V> get value {
    if (RxInterface.proxy != null) {
      RxInterface.proxy.addListener(subject);
    }
    return _value;
  }

  void assign(K key, V val) {
    _value ??= <K, V>{};
    _value.clear();
    _value[key] = val;
    refresh();
  }

  void assignAll(Map<K, V> val) {
    if (_value == val) return;
    _value ??= <K, V>{};
    _value = val;
    refresh();
  }

  @override
  @protected
  @Deprecated('Map.value is deprecated. use [yourMap.assignAll(newMap)]')
  set value(Map<K, V> val) {
    if (_value == val) return;
    _value = val;
    refresh();
  }

  void addIf(dynamic condition, K key, V value) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) {
      _value[key] = value;
      refresh();
    }
  }

  void addAllIf(dynamic condition, Map<K, V> values) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(values);
  }
}

extension MapExtension<K, V> on Map<K, V> {
  RxMap<K, V> get obs {
    return RxMap<K, V>(this);
  }
}
