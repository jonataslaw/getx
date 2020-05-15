import 'dart:math' as math;

class DelegatingList<E> extends DelegatingIterable<E> implements List<E> {
  const DelegatingList(List<E> base) : super(base);

  List<E> get _listBase => _base;

  E operator [](int index) => _listBase[index];

  void operator []=(int index, E value) {
    _listBase[index] = value;
  }

  List<E> operator +(List<E> other) => _listBase + other;

  void add(E value) {
    _listBase.add(value);
  }

  void addAll(Iterable<E> iterable) {
    _listBase.addAll(iterable);
  }

  Map<int, E> asMap() => _listBase.asMap();

  List<T> cast<T>() => _listBase.cast<T>();

  void clear() {
    _listBase.clear();
  }

  void fillRange(int start, int end, [E fillValue]) {
    _listBase.fillRange(start, end, fillValue);
  }

  set first(E value) {
    if (this.isEmpty) throw RangeError.index(0, this);
    this[0] = value;
  }

  Iterable<E> getRange(int start, int end) => _listBase.getRange(start, end);

  int indexOf(E element, [int start = 0]) => _listBase.indexOf(element, start);

  int indexWhere(bool test(E element), [int start = 0]) =>
      _listBase.indexWhere(test, start);

  void insert(int index, E element) {
    _listBase.insert(index, element);
  }

  insertAll(int index, Iterable<E> iterable) {
    _listBase.insertAll(index, iterable);
  }

  set last(E value) {
    if (this.isEmpty) throw RangeError.index(0, this);
    this[this.length - 1] = value;
  }

  int lastIndexOf(E element, [int start]) =>
      _listBase.lastIndexOf(element, start);

  int lastIndexWhere(bool test(E element), [int start]) =>
      _listBase.lastIndexWhere(test, start);

  set length(int newLength) {
    _listBase.length = newLength;
  }

  bool remove(Object value) => _listBase.remove(value);

  E removeAt(int index) => _listBase.removeAt(index);

  E removeLast() => _listBase.removeLast();

  void removeRange(int start, int end) {
    _listBase.removeRange(start, end);
  }

  void removeWhere(bool test(E element)) {
    _listBase.removeWhere(test);
  }

  void replaceRange(int start, int end, Iterable<E> iterable) {
    _listBase.replaceRange(start, end, iterable);
  }

  void retainWhere(bool test(E element)) {
    _listBase.retainWhere(test);
  }

  @deprecated
  List<T> retype<T>() => cast<T>();

  Iterable<E> get reversed => _listBase.reversed;

  void setAll(int index, Iterable<E> iterable) {
    _listBase.setAll(index, iterable);
  }

  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _listBase.setRange(start, end, iterable, skipCount);
  }

  void shuffle([math.Random random]) {
    _listBase.shuffle(random);
  }

  void sort([int compare(E a, E b)]) {
    _listBase.sort(compare);
  }

  List<E> sublist(int start, [int end]) => _listBase.sublist(start, end);
}

class DelegatingIterable<E> extends _DelegatingIterableBase<E> {
  final Iterable<E> _base;

  const DelegatingIterable(Iterable<E> base) : _base = base;
}

abstract class _DelegatingIterableBase<E> implements Iterable<E> {
  Iterable<E> get _base;

  const _DelegatingIterableBase();

  bool any(bool test(E element)) => _base.any(test);

  Iterable<T> cast<T>() => _base.cast<T>();

  bool contains(Object element) => _base.contains(element);

  E elementAt(int index) => _base.elementAt(index);

  bool every(bool test(E element)) => _base.every(test);

  Iterable<T> expand<T>(Iterable<T> f(E element)) => _base.expand(f);

  E get first => _base.first;

  E firstWhere(bool test(E element), {E orElse()}) =>
      _base.firstWhere(test, orElse: orElse);

  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      _base.fold(initialValue, combine);

  Iterable<E> followedBy(Iterable<E> other) => _base.followedBy(other);

  void forEach(void f(E element)) => _base.forEach(f);

  bool get isEmpty => _base.isEmpty;

  bool get isNotEmpty => _base.isNotEmpty;

  Iterator<E> get iterator => _base.iterator;

  String join([String separator = ""]) => _base.join(separator);

  E get last => _base.last;

  E lastWhere(bool test(E element), {E orElse()}) =>
      _base.lastWhere(test, orElse: orElse);

  int get length => _base.length;

  Iterable<T> map<T>(T f(E element)) => _base.map(f);

  E reduce(E combine(E value, E element)) => _base.reduce(combine);

  @deprecated
  Iterable<T> retype<T>() => cast<T>();

  E get single => _base.single;

  E singleWhere(bool test(E element), {E orElse()}) {
    return _base.singleWhere(test, orElse: orElse);
  }

  Iterable<E> skip(int n) => _base.skip(n);

  Iterable<E> skipWhile(bool test(E value)) => _base.skipWhile(test);

  Iterable<E> take(int n) => _base.take(n);

  Iterable<E> takeWhile(bool test(E value)) => _base.takeWhile(test);

  List<E> toList({bool growable = true}) => _base.toList(growable: growable);

  Set<E> toSet() => _base.toSet();

  Iterable<E> where(bool test(E element)) => _base.where(test);

  Iterable<T> whereType<T>() => _base.whereType<T>();

  String toString() => _base.toString();
}
