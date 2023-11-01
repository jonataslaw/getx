import 'dart:async';

import '../get_utils/get_utils.dart';

/// An extension on [num] providing utility methods for numerical comparisons.
extension GetNumUtilsExt<T> on num {
  /// Checks if the current numerical value is lower than the provided [b].
  ///
  /// This method compares the current numerical value with [b] and returns `true`
  /// if the current value is strictly lower (less than) than [b]. Otherwise, it returns `false`.
  ///
  /// Example usage:
  /// ```dart
  /// final a = 10;
  /// final b = 20;
  ///
  /// final result = a.isLowerThan(b); // Result: true
  /// ```
  bool isLowerThan(final num b) => GetUtils.isLowerThan(this, b);

  /// Checks if the current numerical value is greater than the provided [b].
  ///
  /// This method compares the current numerical value with [b] and returns `true`
  /// if the current value is strictly greater (greater than) than [b]. Otherwise, it returns `false`.
  ///
  /// Example usage:
  /// ```dart
  /// final a = 30.5;
  /// final b = 20.0;
  ///
  /// final result = a.isGreaterThan(b); // Result: true
  /// ```
  bool isGreaterThan(final num b) => GetUtils.isGreaterThan(this, b);

  /// Checks if the current numerical value is equal to the provided [b].
  ///
  /// This method compares the current numerical value with [b] and returns `true`
  /// if they are equal (have the same value). Otherwise, it returns `false`.
  ///
  /// Example usage:
  /// ```dart
  /// final a = 42;
  /// final b = 42;
  ///
  /// final result = a.isEqual(b); // Result: true
  /// ```
  bool isEqual(final num b) => GetUtils.isEqual(this, b);

  /// Utility to delay some callback (or code execution).
  /// TODO: Add a separated implementation of delay() with the ability
  /// to stop it.
  ///
  /// Sample:
  /// ```
  /// void main() async {
  ///   print('+ wait for 2 seconds');
  ///   await 2.delay();
  ///   print('- 2 seconds completed');
  ///   print('+ callback in 1.2sec');
  ///   1.delay(() => print('- 1.2sec callback called'));
  ///   print('currently running callback 1.2sec');
  /// }
  ///```
  Future<T> delay([final FutureOr<T> Function()? callback]) async =>
      Future<T>.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );
}
