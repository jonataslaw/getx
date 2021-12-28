part of rx_types;

class RxSet<E> extends SetMixin<E>
    with NotifyManager<Set<E>>, RxObjectMixin<Set<E>>
    implements RxInterface<Set<E>> {
  RxSet([Set<E> initial = const {}]) {
    subject = GetStream.fromValue(Set.from(initial));
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  RxSet<E> operator +(Set<E> val) {
    addAll(val);
    refresh();
    return this;
  }

  void update(void fn(Iterable<E>? value)) {
    fn(value);
    refresh();
  }

  @override
  @protected
  Set<E> get value {
    return subject.value;
    // RxInterface.proxy?.addListener(subject);
    // return _value;
  }

  @override
  @protected
  set value(Set<E> val) {
    if (value == val) return;
    value = val;
    refresh();
  }

  @override
  bool add(E newValue) {
    final val = value.add(newValue);
    refresh();
    return val;
  }

  @override
  bool contains(Object? element) {
    return value.contains(element);
  }

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  int get length => value.length;

  @override
  E? lookup(Object? object) {
    return value.lookup(object);
  }

  @override
  bool remove(Object? item) {
    var hasRemoved = value.remove(item);
    if (hasRemoved) {
      refresh();
    }
    return hasRemoved;
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  void addAll(Iterable<E> item) {
    value.addAll(item);
    refresh();
  }

  @override
  void clear() {
    value.clear();
    refresh();
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    value.removeAll(elements);
    refresh();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    value.retainAll(elements);
    refresh();
  }

  @override
  void retainWhere(bool Function(E) E) {
    value.retainWhere(E);
    refresh();
  }
}

extension SetExtension<E> on Set<E> {
  RxSet<E> get obs {
    return RxSet<E>(<E>{})..addAll(this);
  }

  // /// Add [item] to [List<E>] only if [item] is not null.
  // void addNonNull(E item) {
  //   if (item != null) add(item);
  // }

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
    // if (this is RxSet) {
    //   (this as RxSet)._value;
    // }

    clear();
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    // if (this is RxSet) {
    //   (this as RxSet)._value;
    // }
    clear();
    addAll(items);
  }
}
