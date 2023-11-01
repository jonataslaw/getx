part of '../rx_types.dart';

/// Create a list similar to `List<T>`
class RxList<E> extends GetListenable<List<E>>
    with ListMixin<E>, RxObjectMixin<List<E>> {
  RxList([super.initial = const <Never>[]]);

  factory RxList.filled(final int length, final E fill,
      {final bool growable = false}) {
    return RxList<E>(List<E>.filled(length, fill, growable: growable));
  }

  factory RxList.empty({final bool growable = false}) {
    return RxList<E>(List<E>.empty(growable: growable));
  }

  /// Creates a list containing all [elements].
  factory RxList.from(final Iterable<E> elements,
      {final bool growable = true}) {
    return RxList<E>(List<E>.from(elements, growable: growable));
  }

  /// Creates a list from [elements].
  factory RxList.of(final Iterable<E> elements, {final bool growable = true}) {
    return RxList<E>(List<E>.of(elements, growable: growable));
  }

  /// Generates a list of values.
  factory RxList.generate(
      final int length, final E Function(int index) generator,
      {final bool growable = true}) {
    return RxList<E>(List<E>.generate(length, generator, growable: growable));
  }

  /// Creates an unmodifiable list containing all [elements].
  factory RxList.unmodifiable(final Iterable<E> elements) {
    return RxList<E>(List<E>.unmodifiable(elements));
  }

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  void operator []=(final int index, final E val) {
    value[index] = val;
    refresh();
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  @override
  RxList<E> operator +(final Iterable<E> val) {
    addAll(val);
    // refresh();
    return this;
  }

  @override
  E operator [](final int index) {
    return value[index];
  }

  @override
  void add(final E element) {
    value.add(element);
    refresh();
  }

  @override
  void addAll(final Iterable<E> iterable) {
    value.addAll(iterable);
    refresh();
  }

  @override
  bool remove(final Object? element) {
    final bool removed = value.remove(element);
    refresh();
    return removed;
  }

  @override
  void removeWhere(final bool Function(E element) test) {
    value.removeWhere(test);
    refresh();
  }

  @override
  void retainWhere(final bool Function(E element) test) {
    value.retainWhere(test);
    refresh();
  }

  @override
  int get length => value.length;

  // @override
  // @protected
  // List<E> get value {
  //   RxInterface.proxy?.addListener(subject);
  //   return subject.value;
  // }

  @override
  set length(final int newLength) {
    value.length = newLength;
    refresh();
  }

  @override
  void insertAll(final int index, final Iterable<E> iterable) {
    value.insertAll(index, iterable);
    refresh();
  }

  @override
  Iterable<E> get reversed => value.reversed;

  // @override
  // set value(List<E> val) {
  //   value = val;
  //   refresh();
  // }

  @override
  Iterable<E> where(final bool Function(E) test) {
    return value.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return value.whereType<T>();
  }

  @override
  void sort([final int Function(E a, E b)? compare]) {
    value.sort(compare);
    refresh();
  }
}

extension ListExtension<E> on List<E> {
  RxList<E> get obs => RxList<E>(this);

  /// Add [item] to [List<E>] only if [item] is not null.
  void addNonNull(final E item) {
    if (item != null) {
      add(item);
    }
  }

  // /// Add [Iterable<E>] to [List<E>] only if [Iterable<E>] is not null.
  // void addAllNonNull(Iterable<E> item) {
  //   if (item != null) addAll(item);
  // }

  /// Add [item] to List<E> only if [condition] is true.
  void addIf(dynamic condition, final E item) {
    if (condition is Condition) {
      condition = condition();
    }
    if (condition is bool && condition) {
      add(item);
    }
  }

  /// Adds [Iterable<E>] to [List<E>] only if [condition] is true.
  void addAllIf(dynamic condition, final Iterable<E> items) {
    if (condition is Condition) {
      condition = condition();
    }
    if (condition is bool && condition) {
      addAll(items);
    }
  }

  /// Replaces all existing items of this list with [item]
  void assign(final E item) {
    // if (this is RxList) {
    //   (this as RxList)._value;
    // }

    if (this is RxList) {
      (this as RxList<E>).value.clear();
    }
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(final Iterable<E> items) {
    if (this is RxList) {
      (this as RxList<E>).value.clear();
    }
    //clear();
    addAll(items);
  }
}
