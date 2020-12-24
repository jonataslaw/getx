// ignore: prefer_mixin
import 'package:flutter/widgets.dart';

import '../rx_flutter/rx_disposable.dart';
import '../rx_flutter/rx_notifier.dart';
import 'list_notifier.dart';

// ignore: prefer_mixin
abstract class GetxController extends DisposableInterface with ListNotifier {
  /// Rebuilds [GetBuilder] each time you call [update()];
  /// Can take a List of [ids], that will only update the matching
  /// `GetBuilder( id: )`,
  /// [ids] can be reused among `GetBuilders` like group tags.
  /// The update will only notify the Widgets, if [condition] is true.
  void update([List<String> ids, bool condition = true]) {
    if (!condition) {
      return;
    }
    if (ids == null) {
      refresh();
    } else {
      for (final id in ids) {
        refreshGroup(id);
      }
    }
  }
}

abstract class RxController extends DisposableInterface {}

abstract class SuperController<T> extends FullLifeCycleController
    with FullLifeCycle, StateMixin<T> {}

abstract class FullLifeCycleController extends GetxController
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver {}

mixin FullLifeCycle on FullLifeCycleController {
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @mustCallSuper
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed();
  void onPaused();
  void onInactive();
  void onDetached();
}
