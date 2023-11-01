import 'dart:async';

/// A utility class for managing microtasks and scheduling asynchronous callbacks.
class GetMicrotask {
  int _version = 0;
  int _microtask = 0;

  int get microtask => _microtask;
  int get version => _version;

  /// Executes the provided [callback] as a microtask.
  ///
  /// This method ensures that the callback is executed as a microtask only if
  /// no other microtasks are pending. It maintains a version counter to track
  /// the execution state.
  ///
  /// Example usage:
  /// ```dart
  /// final microtask = GetMicrotask();
  /// microtask.exec(() {
  ///   // Your callback logic here.
  /// });
  /// ```
  void exec(final Function callback) {
    if (_microtask == _version) {
      _microtask++;
      scheduleMicrotask(() {
        _version++;
        _microtask = _version;
        callback();
      });
    }
  }
}

/// A queue manager class for handling asynchronous jobs.
class GetQueue {
  final List<_Item> _queue = [];
  bool _active = false;

  /// Adds a job to the queue and returns a [Future] that completes when the job is done.
  ///
  /// The [job] function is expected to return a value, which will be the result
  /// of the future.
  ///
  /// Example usage:
  /// ```dart
  /// final queue = GetQueue();
  /// final result = await queue.add<int>(() {
  ///   // Your asynchronous job logic here.
  ///   return 42; // Return the result of the job.
  /// });
  /// ```
  Future<T> add<T>(final Function job) {
    final completer = Completer<T>();
    _queue.add(_Item(completer, job));
    _check();
    return completer.future;
  }

  /// Cancels all jobs in the queue.
  void cancelAllJobs() {
    _queue.clear();
  }

  void _check() async {
    if (!_active && _queue.isNotEmpty) {
      _active = true;
      final item = _queue.removeAt(0);
      try {
        item.completer.complete(await item.job());
      } on Exception catch (e) {
        item.completer.completeError(e);
      }
      _active = false;
      _check();
    }
  }
}

/// Represents an item in the job queue.
class _Item {

  _Item(this.completer, this.job);
  final dynamic completer;
  final dynamic job;
}
