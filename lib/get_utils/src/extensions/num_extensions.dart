import 'dart:async';

import '../get_utils/get_utils.dart';

extension GetNumUtils on num {
  bool isLowerThan(num b) => GetUtils.isLowerThan(this, b);

  bool isGreaterThan(num b) => GetUtils.isGreaterThan(this, b);

  bool isEqual(num b) => GetUtils.isEqual(this, b);

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
  Future delay([FutureOr Function()? callback]) async => Future.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );

  /// Easy way to make Durations from numbers.
  ///
  /// Sample:
  /// ```
  /// print(1.seconds + 200.milliseconds);
  /// print(1.hours + 30.minutes);
  /// print(1.5.hours);
  ///```
}
