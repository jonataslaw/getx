import 'dart:async';

import '../../../get_core/src/get_interface.dart';

/// An extension on [GetInterface] providing utility methods for managing asynchronous code execution within the event loop.
extension LoopEventsExt on GetInterface {
  /// Executes a computation asynchronously, allowing the event loop to process other tasks
  /// before running the provided computation.
  ///
  /// This method can be useful for deferring non-blocking computations that might be
  /// computationally expensive, allowing other asynchronous operations to proceed.
  ///
  /// Example usage:
  /// ```dart
  /// await myObject.toEnd(() async {
  ///   // Perform a computationally expensive operation asynchronously
  ///   await someAsyncOperation();
  ///   return result;
  /// });
  /// ```
  Future<T> toEnd<T>(FutureOr<T> Function() computation) async {
    await Future<T>.delayed(Duration.zero);
    final FutureOr<T> val = computation();
    return val;
  }

  /// Executes a computation asynchronously, allowing the event loop to process other tasks
  /// before running the provided computation. Optionally, a `condition` can be provided
  /// to determine whether the computation should be executed immediately or delayed.
  ///
  /// This method can be useful when you want to conditionally run an asynchronous operation
  /// and allow other asynchronous tasks to proceed when the condition is not met.
  ///
  /// Example usage:
  /// ```dart
  /// await myObject.asap(() {
  ///   // Perform some task immediately
  ///   return result;
  /// }, condition: () {
  ///   // Provide a condition to decide whether the task should be delayed
  ///   return shouldDelayTask();
  /// });
  /// ```
  FutureOr<T> asap<T>(T Function() computation,
      {bool Function()? condition}) async {
    T val;
    if (condition == null || !condition()) {
      await Future<T>.delayed(Duration.zero);
      val = computation();
    } else {
      val = computation();
    }
    return val;
  }
}
