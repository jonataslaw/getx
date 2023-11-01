part of rx_types;

class RxSet<E> extends GetListenable<Set<E>>
    with SetMixin<E>, RxObjectMixin<Set<E>> {
  RxSet([final Set<E> initial = const {}]) : super(initial);

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  RxSet<E> operator +(final Set<E> val) {
    addAll(val);
    //refresh();
    return this;
  }

  void update(final void Function(Iterable<E>? value) fn) {
    fn(value);
    refresh();
  }

  // @override
  // @protected
  // Set<E> get value {
  //   return subject.value;
  //   // RxInterface.proxy?.addListener(subject);
  //   // return _value;
  // }

  // @override
  // @protected
  // set value(Set<E> val) {
  //   if (value == val) return;
  //   value = val;
  //   refresh();
  // }

  @override
  bool add(final E value) {
    final hasAdded = this.value.add(value);
    if (hasAdded) {
      refresh();
    }
    return hasAdded;
  }

  @override
  bool contains(final Object? element) {
    return value.contains(element);
  }

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  int get length => value.length;

  @override
  E? lookup(final Object? element) {
    return value.lookup(element);
  }

  @override
  bool remove(final Object? value) {
    var hasRemoved = this.value.remove(value);
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
  void addAll(final Iterable<E> elements) {
    value.addAll(elements);
    refresh();
  }

  @override
  void clear() {
    value.clear();
    refresh();
  }

  @override
  void removeAll(final Iterable<Object?> elements) {
    value.removeAll(elements);
    refresh();
  }

  @override
  void retainAll(final Iterable<Object?> elements) {
    value.retainAll(elements);
    refresh();
  }

  @override
  void retainWhere(final bool Function(E) test) {
    value.retainWhere(test);
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
    // if (this is RxSet) {
    //   (this as RxSet)._value;
    // }

    clear();
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(final Iterable<E> items) {
    // if (this is RxSet) {
    //   (this as RxSet)._value;
    // }
    clear();
    addAll(items);
  }
}
