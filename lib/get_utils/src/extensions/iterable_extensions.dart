extension IterableExtensions<T> on Iterable<T> {
  Iterable<TRes> mapMany<TRes>(
      final Iterable<TRes>? Function(T item) selector) sync* {
    for (final item in this) {
      final res = selector(item);
      if (res != null) yield* res;
    }
  }
}
