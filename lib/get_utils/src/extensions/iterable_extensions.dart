/// Useful extensions for `Iterable`.
extension IterableExtensions<T> on Iterable<T> {
  /// Maps each element of the `Iterable` to an `Iterable<TRes>` and flattens
  /// the resulting iterables into a single `Iterable<TRes>`.
  ///
  /// If the `selector` returns `null` for an element, it is ignored.
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
