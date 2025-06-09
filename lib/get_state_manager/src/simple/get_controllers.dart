// ignore: prefer_mixin
import 'package:flutter/widgets.dart';

import '../../../instance_manager.dart';
import '../rx_flutter/rx_notifier.dart';
import 'list_notifier.dart';

/// A base controller class that provides state management functionality.
///
/// Extend this class to create a controller that can be used with GetX's
/// state management system. This class provides methods to update the UI
/// when the controller's state changes.
///
/// Example:
/// ```dart
/// class CounterController extends GetxController {
///   var count = 0;
///
///   void increment() {
///     count++;
///     update(); // Triggers UI update
///   }
/// }
/// ```
// ignore: prefer_mixin
abstract class GetxController extends ListNotifier with GetLifeCycleMixin {
  /// Notifies listeners to update the UI.
  ///
  /// When called without parameters, it will update all widgets that depend on
  /// this controller. You can also specify specific widget IDs to update only
  /// those widgets.
  ///
  /// Parameters:
  /// - [ids]: Optional list of widget IDs to update. If null, updates all widgets.
  /// - [condition]: If false, the update will be skipped.
  ///
  void update([List<Object>? ids, bool condition = true]) {
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

/// A mixin that provides scroll-based data fetching capabilities.
///
/// This mixin can be used with controllers that need to load more data
/// when the user scrolls to the top or bottom of a scrollable view.
///
/// Example:
/// ```dart
/// class MyController extends GetxController with ScrollMixin {
///   @override
///   Future<void> onEndScroll() async {
///     // Load more data when scrolled to bottom
///   }
///
///   @override
///   Future<void> onTopScroll() async {
///     // Load previous data when scrolled to top
///   }
/// }
/// ```
mixin ScrollMixin on GetLifeCycleMixin {
  /// The scroll controller used to detect scroll position
  final ScrollController scroll = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_listener);
  }

  /// Flag to prevent multiple simultaneous bottom fetches
  bool _canFetchBottom = true;

  /// Flag to prevent multiple simultaneous top fetches
  bool _canFetchTop = true;

  void _listener() {
    if (scroll.position.atEdge) {
      _checkIfCanLoadMore();
    }
  }

  Future<void> _checkIfCanLoadMore() async {
    if (scroll.position.pixels == 0) {
      if (!_canFetchTop) return;
      _canFetchTop = false;
      await onTopScroll();
      _canFetchTop = true;
    } else {
      if (!_canFetchBottom) return;
      _canFetchBottom = false;
      await onEndScroll();
      _canFetchBottom = true;
    }
  }

  /// this method is called when the scroll is at the bottom
  Future<void> onEndScroll();

  /// this method is called when the scroll is at the top
  Future<void> onTopScroll();

  @override
  void onClose() {
    scroll.removeListener(_listener);
    scroll.dispose();
    super.onClose();
  }
}

/// A base controller class for reactive state management using Rx variables.
///
/// This class is a lightweight alternative to [GetxController] when you only
/// need reactive variables without the need for manual UI updates.
///
/// Example:
/// ```dart
/// class UserController extends RxController {
///   final name = 'John'.obs;
///   final age = 30.obs;
/// }
/// ```
abstract class RxController with GetLifeCycleMixin {}

/// A controller that manages state for asynchronous operations.
///
/// This controller provides a standard way to handle loading, error, and success
/// states for async operations. It's particularly useful for API calls and
/// other asynchronous operations.
///
/// Type parameters:
/// - [T]: The type of data this controller will manage
///
/// Example:
/// ```dart
/// class UserController extends StateController<User> {
///   Future<void> fetchUser() async {
///     change(null, status: RxStatus.loading());
///     try {
///       final user = await userRepository.getUser();
///       change(user, status: RxStatus.success());
///     } catch (e) {
///       change(state, status: RxStatus.error(e.toString()));
///     }
///   }
/// }
/// ```
abstract class StateController<T> extends GetxController with StateMixin<T> {}

/// A controller that combines full lifecycle management with state management.
///
/// This controller is ideal for complex scenarios where you need both:
/// 1. Full app lifecycle awareness
/// 2. State management with loading/error states
///
/// Type parameters:
/// - [T]: The type of data this controller will manage
///
/// Example:
/// ```dart
/// class HomeController extends SuperController<HomeState> {
///   @override
///   void onResumed() {
///     // App came to foreground
///     fetchData();
///   }
///
///   Future<void> fetchData() async {
///     change(state, status: RxStatus.loading());
///     try {
///       final data = await repository.getData();
///       change(HomeState(data: data), status: RxStatus.success());
///     } catch (e) {
///       change(state, status: RxStatus.error(e.toString()));
///     }
///   }
/// }
/// ```
abstract class SuperController<T> extends FullLifeCycleController
    with FullLifeCycleMixin, StateMixin<T> {}

/// A controller that can observe the full app lifecycle.
///
/// This controller extends [GetxController] and implements [WidgetsBindingObserver]
/// to provide full lifecycle awareness. It can respond to:
/// - App lifecycle changes (resumed, paused, etc.)
/// - Memory pressure events
/// - Accessibility changes
///
/// Note: Don't forget to call `super.onClose()` in your controller's
/// [onClose] method to properly clean up the observer.
///
/// Example:
/// ```dart
/// class MyController extends FullLifeCycleController {
///   @override
///   void onResumed() {
///     // App came to foreground
///   }
///
///   @override
///   void onPaused() {
///     // App went to background
///   }
///
///   @override
///   void onClose() {
///     // Clean up resources
///     super.onClose();
///   }
/// }
/// ```
abstract class FullLifeCycleController extends GetxController
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver {}

/// A mixin that provides full lifecycle callbacks for the controller.
///
/// This mixin handles app lifecycle events, memory pressure, and accessibility changes.
/// Override the provided methods to respond to these events.
///
/// Example:
/// ```dart
/// class MyController extends FullLifeCycleController with FullLifeCycleMixin {
///   @override
///   void onResumed() {
///     // App came to foreground
///   }
///
///   @override
///   void onMemoryPressure() {
///     // Clean up resources when system is low on memory
///   }
/// }
/// ```
mixin FullLifeCycleMixin on FullLifeCycleController {
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    Engine.instance.addObserver(this);
  }

  @mustCallSuper
  @override
  void onClose() {
    Engine.instance.removeObserver(this);
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
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    onMemoryPressure();
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    onAccessibilityChanged();
  }

  /// Called when the system reports that the app is visible and interactive.
  /// This is called when the app returns to the foreground.
  void onResumed() {}

  /// Called when the app is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void onPaused() {}

  /// Called when the app is in an inactive state and is not receiving user input.
  /// For example, when a phone call is received or when the app is in a
  /// multi-window mode.
  void onInactive() {}

  /// Called before the app is destroyed.
  /// This is the final callback the app will receive before it is terminated.
  void onDetached() {}

  /// Called when the app is hidden (e.g., when the device is locked).
  void onHidden() {}

  /// Called when the system is running low on memory.
  /// Override this method to release caches or other resources that aren't
  /// critical for the app to function.
  void onMemoryPressure() {}

  /// Called when the system changes the set of currently active accessibility
  /// features.
  void onAccessibilityChanged() {}
}
