import 'package:flutter/scheduler.dart';
import '../../get_state_manager.dart';

/// Used like [SingleTickerProviderMixin] but only with Get Controllers.
/// Simplifies AnimationController creation inside GetxController.
///
/// Example:
///```
///class SplashController extends GetxController with
///    SingleGetTickerProviderMixin {
///  AnimationController _ac;
///
///  @override
///  void onInit() {
///    final dur = const Duration(seconds: 2);
///    _ac = AnimationController.unbounded(duration: dur, vsync: this);
///    _ac.repeat();
///    _ac.addListener(() => print("Animation Controller value: ${_ac.value}"));
///  }
///  ...
/// ```
mixin SingleGetTickerProviderMixin on DisposableInterface
    implements TickerProvider {
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
