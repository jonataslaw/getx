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

class GetQueue {
  final List<_Item> _queue = [];
  bool _active = false;

  Future<T> add<T>(Function job) {
    var completer = Completer<T>();
    _queue.add(_Item(completer, job));
    _check();
    return completer.future;
  }

  void cancelAllJobs() {
    _queue.clear();
  }

  void _check() async {
    if (!_active && _queue.isNotEmpty) {
      _active = true;
      var item = _queue.removeAt(0);
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

class _Item {
  final dynamic completer;
  final dynamic job;

  _Item(this.completer, this.job);
}
