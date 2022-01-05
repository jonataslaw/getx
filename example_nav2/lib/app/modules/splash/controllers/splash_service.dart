import 'dart:async';

import 'package:get/get.dart';
import 'package:async/async.dart';

class SplashService extends GetxService {
  final welcomeStr = ['GetX', 'Rules!'];
  final activeStr = 0.obs;

  final memo = AsyncMemoizer<void>();
  Future<void> init() {
    return memo.runOnce(_initFunction);
  }

  void _changeActiveString() {
    activeStr.value = (activeStr.value + 1) % welcomeStr.length;
  }

  Future<void> _initFunction() async {
    final t = Timer.periodic(
      Duration(milliseconds: 500),
      (t) => _changeActiveString(),
    );
    //simulate some long running operation
    await Future.delayed(Duration(seconds: 5));
    //cancel the timer once we are done
    t.cancel();
  }
}
