extension IterableExtensions<T> on Iterable<T> {
  Iterable<TRes> mapMany<TRes>(
      Iterable<TRes>? Function(T item) selector) sync* {
    for (var item in this) {
      final res = selector(item);
      if (res != null) yield* res;
    }
  }
}

/// The some() method checks if any array elements pass a test
/// The some() method executes the callback function once for each array element
/// The some() method returns true (and stops) if the function returns true for one of the array elements
/// The some() method returns false if the function returns false for all of the array elements
/// The some() method does not execute the function for empty array elements
/// The some() method does not change the original array
///
/// Example:
///  var ages = [3.5, 10.11, 18.56, 20.0, 88.89];
///  var resultTrue = ages.some((age) => age == 88.89);
///  print(resultTrue);

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
