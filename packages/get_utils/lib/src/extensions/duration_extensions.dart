import 'dart:ui';

/// Duration utilities.
extension GetDurationUtils on Duration {
  /// Utility to delay some callback (or code execution).
  ///
  /// Sample:
  /// ```
  /// void main() async {
  ///   final _delay = 3.seconds;
  ///   print('+ wait $_delay');
  ///   await _delay.delay();
  ///   print('- finish wait $_delay');
  ///   print('+ callback in 700ms');
  ///   await 0.7.seconds.delay(() {
  /// }
  ///```
  Future delay([VoidCallback callback]) async => Future.delayed(this, callback);
}
