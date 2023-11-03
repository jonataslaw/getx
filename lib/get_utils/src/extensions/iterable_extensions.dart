extension IterableExtensions<T> on Iterable<T> {
  Iterable<TRes> mapMany<TRes>(
      final Iterable<TRes>? Function(T item) selector) sync* {
    for (final T item in this) {
      final Iterable<TRes>? res = selector(item);
      if (res != null) {
        yield* res;
      }
    }
  }
}
