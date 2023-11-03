import 'dart:async';

import '../get_utils/get_utils.dart';

extension GetNumUtils on num {
  bool isLowerThan(final num b) => GetUtils.isLowerThan(this, b);

  bool isGreaterThan(final num b) => GetUtils.isGreaterThan(this, b);

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
  Future delay([final FutureOr Function()? callback]) async => Future.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );
}
