extension IterableExtensions<T> on Iterable<T> {
  Iterable<TRes> mapMany<TRes>(
      Iterable<TRes>? Function(T item) selector) sync* {
    for (var item in this) {
      final res = selector(item);
      if (res != null) yield* res;
    }
  }
}

extension FineSome<T> on Iterable<T> {
  bool some(bool Function(T item) checkItem) {
    for (var item in this) {
      var check = checkItem.call(item);
      if (check == true) {
        return true;
      }
    }
    return false;
  }
}
