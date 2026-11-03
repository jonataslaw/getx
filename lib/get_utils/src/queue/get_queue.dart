import 'dart:async';

class GetMicrotask {
  int _version = 0;
  int _microtask = 0;

  int get microtask => _microtask;
  int get version => _version;

  void exec(Function callback) {
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

/// Runs jobs one at a time in the order they were added.
class GetQueue {
  final List<_Item> _queue = [];
  bool _active = false;

  /// Enqueues [job] and forwards its result or original error and stack trace.
  ///
  /// The job can return a value or a future. When the queue is idle, its first
  /// job starts immediately. See [cancelAllJobs] before awaiting jobs that may
  /// be discarded.
  Future<T> add<T>(Function job) {
    var completer = Completer<T>();
    _queue.add(_Item(completer, job));
    _check();
    return completer.future;
  }

  /// Discards queued jobs that have not started.
  ///
  /// The running job continues and its future still completes normally or with
  /// an error. Futures returned by [add] for discarded jobs remain pending;
  /// this method does not provide a cancellation result for them. Jobs added
  /// afterward can run once the running job finishes.
  void cancelAllJobs() {
    _queue.clear();
  }

  void _check() async {
    if (!_active && _queue.isNotEmpty) {
      _active = true;
      var item = _queue.removeAt(0);
      try {
        item.completer.complete(await item.job());
      } catch (error, stackTrace) {
        item.completer.completeError(error, stackTrace);
      } finally {
        _active = false;
      }
      _check();
    }
  }
}

class _Item {
  final dynamic completer;
  final dynamic job;

  _Item(this.completer, this.job);
}
