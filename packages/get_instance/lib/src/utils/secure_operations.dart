import 'dart:async';

class GetQueue {
  final List<_Item> _queue = [];
  bool _active = false;

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

  Future<T> secure<T>(Function job) {
    var completer = Completer<T>();
    _queue.add(_Item<T>(completer, job));
    _check();
    return completer.future;
  }
}

class _Item<T> {
  final Completer<T> completer;
  final Function job;

  _Item(this.completer, this.job);
}
