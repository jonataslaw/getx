/// An extension on [Iterable] providing utility methods for working with collections of elements.
extension IterableExt<T> on Iterable<T> {
  /// Maps each element in the iterable to an iterable using the provided selector function
  /// and flattens the result into a single iterable.
  ///
  /// This method applies the provided [selector] function to each element in the iterable.
  /// If the selector returns a non-null iterable, the elements of that iterable are
  /// flattened into the result. If the selector returns `null`, the element is skipped.
  ///
  /// Example usage:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final result = numbers.mapMany((n) => n % 2 == 0 ? [n, n * 2] : null);
  /// // Result: [2, 4]
  /// ```
  ///
  /// The [selector] function returns an [Iterable] of type `TRes` or `null`.
  Iterable<TRes> mapMany<TRes>(
      Iterable<TRes>? Function(T item) selector) sync* {
    for (final T item in this) {
      final Iterable<TRes>? res = selector(item);
      if (res != null) {
        yield* res;
      }
    }
  }

  /// Returns the first element in the iterable, or `null` if the iterable is empty.
  ///
  /// This method retrieves the first element of the iterable or returns `null` if the
  /// iterable is empty. It is a safe way to access the first element without throwing
  /// an exception.
  ///
  /// Example usage:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final firstNumber = numbers.firstOrNull;
  /// // Result: 1
  ///
  /// final emptyList = <int>[];
  /// final firstElement = emptyList.firstOrNull;
  /// // Result: null
  /// ```
  T? get firstOrNull {
    final Iterator<T> iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
