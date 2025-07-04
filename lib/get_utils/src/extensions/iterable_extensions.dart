extension IterableExtensions<T> on Iterable<T> {
  Iterable<TRes> mapMany<TRes>(
    Iterable<TRes>? Function(T item) selector,
  ) sync* {
    for (var item in this) {
      final res = selector(item);
      if (res != null) yield* res;
    }
  }

  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
