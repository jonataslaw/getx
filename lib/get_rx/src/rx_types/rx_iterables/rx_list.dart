part of rx_types;

/// Create a list similar to `List<T>`
class RxList<E> extends ListMixin<E>
    with NotifyManager<List<E>>, RxObjectMixin<List<E>>
    implements RxInterface<List<E>> {
  RxList([List<E> initial = const []]) {
    _value = List.from(initial);
  }

  factory RxList.filled(int length, E fill, {bool growable = false}) {
    return RxList(List.filled(length, fill, growable: growable));
  }

  factory RxList.empty({bool growable = false}) {
    return RxList(List.empty(growable: growable));
  }

  /// Creates a list containing all [elements].
  factory RxList.from(Iterable elements, {bool growable = true}) {
    return RxList(List.from(elements, growable: growable));
  }

  /// Creates a list from [elements].
  factory RxList.of(Iterable<E> elements, {bool growable = true}) {
    return RxList(List.of(elements, growable: growable));
  }

  /// Generates a list of values.
  factory RxList.generate(int length, E generator(int index),
      {bool growable = true}) {
    return RxList(List.generate(length, generator, growable: growable));
  }

  /// Creates an unmodifiable list containing all [elements].
  factory RxList.unmodifiable(Iterable elements) {
    return RxList(List.unmodifiable(elements));
  }

  @override
  Iterator<E> get iterator => value.iterator;

  Iterable get iterable => value;

  @override
  void operator []=(int index, E val) {
    _value[index] = val;
    refresh();
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  @override
  RxList<E> operator +(Iterable<E> val) {
    addAll(val);
    refresh();
    return this;
  }

  @override
  E operator [](int index) {
    return value[index];
  }

  @override
  void add(E item) {
    _value.add(item);
    refresh();
  }

  @override
  void addAll(Iterable<E> item) {
    _value.addAll(item);
    refresh();
  }

  @override
  int get length => value.length;

  @override
  @protected
  List<E> get value {
    if (RxInterface.proxy != null) {
      RxInterface.proxy!.addListener(subject);
    }
    return _value;
  }

  @override
  set length(int newLength) {
    _value.length = newLength;
    refresh();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _value.insertAll(index, iterable);
    refresh();
  }

  @override
  Iterable<E> get reversed => value.reversed;

  @override
  Iterable<E> where(bool Function(E e) test) {
    return value.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return value.whereType<T>();
  }

  /// Returns the first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  ///
  /// The [orElse] function can return a [Null] type
  ///
  E? firstWhereOrNull(
    bool Function(E e) test, {
    E? Function()? orElse,
  }) {
    final index = value.indexWhere(test);
    if (index != -1) return value[index];
    if (orElse == null) {
      throw StateError('No element');
    }
    return orElse.call();
  }

  @override
  void sort([int compare(E a, E b)?]) {
    _value.sort(compare?.call);
    refresh();
  }
}

extension ListExtension<E> on List<E> {
  RxList<E> get obs => RxList<E>(this);

  /// Add [item] to [List<E>] only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  // /// Add [Iterable<E>] to [List<E>] only if [Iterable<E>] is not null.
  // void addAllNonNull(Iterable<E> item) {
  //   if (item != null) addAll(item);
  // }

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

  /// Replaces all existing items of this list with [item]
  void assign(E item) {
    // if (this is RxList) {
    //   (this as RxList)._value;
    // }

    clear();
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    // if (this is RxList) {
    //   (this as RxList)._value;
    // }
    clear();
    addAll(items);
  }

  /// Replaces all existing items of this list with [items] if non null
  void asignAllIfNonNull(Iterable<E>? items) {
    if (items != null) {
      clear();
      addAll(items);
    }
  }
}
