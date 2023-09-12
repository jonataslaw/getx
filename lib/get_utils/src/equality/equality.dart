import 'dart:collection';

mixin Equality<T> {
  List<T> get props;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        runtimeType == other.runtimeType &&
            DeepCollectionEquality<List<T>>()
                .equals(props, other.props as List<T>);
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ DeepCollectionEquality<List<T>>().hash(props);
  }
}

const int _hashMask = 0x7fffffff;

/// A generic equality relation on objects.
abstract class IEquality<E> {
  const factory IEquality() = DefaultEquality<E>;

  /// Compare two elements for being equal.
  ///
  /// This should be a proper equality relation.
  bool equals(E e1, E e2);

  /// Get a hashcode of an element.
  ///
  /// The hashcode should be compatible with [equals], so that if
  /// `equals(a, b)` then `hash(a) == hash(b)`.
  int hash(E e);

  /// Test whether an object is a valid argument to [equals] and [hash].
  ///
  /// Some implementations may be restricted to only work on specific types
  /// of objects.
  bool isValidKey(Object? o);
}

class DefaultEquality<E> implements IEquality<E> {
  const DefaultEquality();
  @override
  bool equals(Object? e1, Object? e2) => e1 == e2;
  @override
  int hash(Object? e) => e.hashCode;
  @override
  bool isValidKey(Object? o) => true;
}

/// Equality of objects that compares only the identity of the objects.
class IdentityEquality<E> implements IEquality<E> {
  const IdentityEquality();
  @override
  bool equals(E e1, E e2) => identical(e1, e2);
  @override
  int hash(E e) => identityHashCode(e);
  @override
  bool isValidKey(Object? o) => true;
}

class DeepCollectionEquality<T> implements IEquality<T> {
  DeepCollectionEquality();
  final IEquality<T?> _base = const DefaultEquality<Never>();
  final bool _unordered = false;

  @override
  bool equals(T e1, T e2) {
    if (e1 is Set<T>) {
      return e2 is Set<T> && SetEquality<T>(this).equals(e1, e2);
    }
    if (e1 is Map<T, T>) {
      return e2 is Map<T, T> &&
          MapEquality<T, T>(keys: this, values: this).equals(e1, e2);
    }

    if (e1 is List<T>) {
      return e2 is List<T> && ListEquality<T>(this).equals(e1, e2);
    }
    if (e1 is Iterable<T>) {
      return e2 is Iterable<T> && IterableEquality<T>(this).equals(e1, e2);
    }

    return _base.equals(e1, e2);
  }

  @override
  int hash(T? o) {
    if (o is Set<T>) {
      return SetEquality<T>(this).hash(o);
    }
    if (o is Map<T, T>) {
      return MapEquality<T, T>(keys: this, values: this).hash(o);
    }
    if (!_unordered) {
      if (o is List<T>) {
        return ListEquality<T>(this).hash(o);
      }
      if (o is Iterable<T>) {
        return IterableEquality<T>(this).hash(o);
      }
    } else if (o is Iterable<T>) {
      return UnorderedIterableEquality<T>(this).hash(o);
    }
    return _base.hash(o);
  }

  @override
  bool isValidKey(Object? o) =>
      o is Iterable || o is Map || _base.isValidKey(o);
}

/// Equality on lists.
///
/// Two lists are equal if they have the same length and their elements
/// at each index are equal.
class ListEquality<E> implements IEquality<List<E>> {
  const ListEquality(
      [IEquality<E> elementEquality = const DefaultEquality<Never>()])
      : _elementEquality = elementEquality;
  final IEquality<E> _elementEquality;

  @override
  bool equals(List<E>? list1, List<E>? list2) {
    if (identical(list1, list2)) {
      return true;
    }
    if (list1 == null || list2 == null) {
      return false;
    }
    final int length = list1.length;
    if (length != list2.length) {
      return false;
    }
    for (int i = 0; i < length; i++) {
      if (!_elementEquality.equals(list1[i], list2[i])) {
        return false;
      }
    }
    return true;
  }

  @override
  int hash(List<E>? list) {
    if (list == null) {
      return null.hashCode;
    }
    // Jenkins's one-at-a-time hash function.
    // This code is almost identical to the one in IterableEquality, except
    // that it uses indexing instead of iterating to get the elements.
    int hash = 0;
    for (int i = 0; i < list.length; i++) {
      final int c = _elementEquality.hash(list[i]);
      hash = (hash + c) & _hashMask;
      hash = (hash + (hash << 10)) & _hashMask;
      hash ^= hash >> 6;
    }
    hash = (hash + (hash << 3)) & _hashMask;
    hash ^= hash >> 11;
    hash = (hash + (hash << 15)) & _hashMask;
    return hash;
  }

  @override
  bool isValidKey(Object? o) => o is List<E>;
}

/// Equality on maps.
///
/// Two maps are equal if they have the same number of entries, and if the
/// entries of the two maps are pairwise equal on both key and value.
class MapEquality<K, V> implements IEquality<Map<K, V>> {
  const MapEquality(
      {IEquality<K> keys = const DefaultEquality<Never>(),
      IEquality<V> values = const DefaultEquality<Never>()})
      : _keyEquality = keys,
        _valueEquality = values;
  final IEquality<K> _keyEquality;
  final IEquality<V> _valueEquality;

  @override
  bool equals(Map<K, V>? map1, Map<K, V>? map2) {
    if (identical(map1, map2)) {
      return true;
    }
    if (map1 == null || map2 == null) {
      return false;
    }
    final int length = map1.length;
    if (length != map2.length) {
      return false;
    }
    final Map<_MapEntry, int> equalElementCounts = HashMap<_MapEntry, int>();
    for (final K key in map1.keys) {
      final _MapEntry entry = _MapEntry(this, key, map1[key]);
      final int count = equalElementCounts[entry] ?? 0;
      equalElementCounts[entry] = count + 1;
    }
    for (final K key in map2.keys) {
      final _MapEntry entry = _MapEntry(this, key, map2[key]);
      final int? count = equalElementCounts[entry];
      if (count == null || count == 0) {
        return false;
      }
      equalElementCounts[entry] = count - 1;
    }
    return true;
  }

  @override
  int hash(Map<K, V>? map) {
    if (map == null) {
      return null.hashCode;
    }
    int hash = 0;
    for (final K key in map.keys) {
      final int keyHash = _keyEquality.hash(key);
      final int valueHash = _valueEquality.hash(map[key] as V);
      hash = (hash + 3 * keyHash + 7 * valueHash) & _hashMask;
    }
    hash = (hash + (hash << 3)) & _hashMask;
    hash ^= hash >> 11;
    hash = (hash + (hash << 15)) & _hashMask;
    return hash;
  }

  @override
  bool isValidKey(Object? o) => o is Map<K, V>;
}

class _MapEntry<K, V> {
  _MapEntry(this.equality, this.key, this.value);
  final MapEquality<K?, V?> equality;
  final K? key;
  final V? value;

  @override
  int get hashCode =>
      (3 * equality._keyEquality.hash(key) +
          7 * equality._valueEquality.hash(value)) &
      _hashMask;

  @override
  bool operator ==(Object other) =>
      other is _MapEntry<K, V> &&
      equality._keyEquality.equals(key, other.key) &&
      equality._valueEquality.equals(value, other.value);
}

/// Equality on iterables.
///
/// Two iterables are equal if they have the same elements in the same order.
class IterableEquality<E> implements IEquality<Iterable<E>> {
  const IterableEquality(
      [IEquality<E> elementEquality = const DefaultEquality<Never>()])
      : _elementEquality = elementEquality;
  final IEquality<E?> _elementEquality;

  @override
  bool equals(Iterable<E>? elements1, Iterable<E>? elements2) {
    if (identical(elements1, elements2)) {
      return true;
    }
    if (elements1 == null || elements2 == null) {
      return false;
    }
    final Iterator<E> it1 = elements1.iterator;
    final Iterator<E> it2 = elements2.iterator;
    while (true) {
      final bool hasNext = it1.moveNext();
      if (hasNext != it2.moveNext()) {
        return false;
      }
      if (!hasNext) {
        return true;
      }
      if (!_elementEquality.equals(it1.current, it2.current)) {
        return false;
      }
    }
  }

  @override
  int hash(Iterable<E>? elements) {
    if (elements == null) {
      return null.hashCode;
    }
    // Jenkins's one-at-a-time hash function.
    int hash = 0;
    for (final E element in elements) {
      final int c = _elementEquality.hash(element);
      hash = (hash + c) & _hashMask;
      hash = (hash + (hash << 10)) & _hashMask;
      hash ^= hash >> 6;
    }
    hash = (hash + (hash << 3)) & _hashMask;
    hash ^= hash >> 11;
    hash = (hash + (hash << 15)) & _hashMask;
    return hash;
  }

  @override
  bool isValidKey(Object? o) => o is Iterable<E>;
}

/// Equality of sets.
///
/// Two sets are considered equal if they have the same number of elements,
/// and the elements of one set can be paired with the elements
/// of the other set, so that each pair are equal.
class SetEquality<E> extends _UnorderedEquality<E, Set<E>> {
  const SetEquality([super.elementEquality = const DefaultEquality<Never>()]);

  @override
  bool isValidKey(Object? o) => o is Set<E>;
}

abstract class _UnorderedEquality<E, T extends Iterable<E>>
    implements IEquality<T> {
  const _UnorderedEquality(this._elementEquality);
  final IEquality<E> _elementEquality;

  @override
  bool equals(T? elements1, T? elements2) {
    if (identical(elements1, elements2)) {
      return true;
    }
    if (elements1 == null || elements2 == null) {
      return false;
    }
    final HashMap<E, int> counts = HashMap<E, int>(
        equals: _elementEquality.equals,
        hashCode: _elementEquality.hash,
        isValidKey: _elementEquality.isValidKey);
    int length = 0;
    for (final E e in elements1) {
      final int count = counts[e] ?? 0;
      counts[e] = count + 1;
      length++;
    }
    for (final E e in elements2) {
      final int? count = counts[e];
      if (count == null || count == 0) {
        return false;
      }
      counts[e] = count - 1;
      length--;
    }
    return length == 0;
  }

  @override
  int hash(T? elements) {
    if (elements == null) {
      return null.hashCode;
    }
    int hash = 0;
    for (final E element in elements) {
      final int c = _elementEquality.hash(element);
      hash = (hash + c) & _hashMask;
    }
    hash = (hash + (hash << 3)) & _hashMask;
    hash ^= hash >> 11;
    hash = (hash + (hash << 15)) & _hashMask;
    return hash;
  }
}

/// Equality of the elements of two iterables without considering order.
///
/// Two iterables are considered equal if they have the same number of elements,
/// and the elements of one set can be paired with the elements
/// of the other iterable, so that each pair are equal.
class UnorderedIterableEquality<E> extends _UnorderedEquality<E, Iterable<E>> {
  const UnorderedIterableEquality(
      [super.elementEquality = const DefaultEquality<Never>()]);

  @override
  bool isValidKey(Object? o) => o is Iterable<E>;
}
