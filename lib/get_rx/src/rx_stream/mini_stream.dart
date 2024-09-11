part of 'rx_stream.dart';

class Node<T> {
  T? data;
  Node<T>? next;
  Node<T>? prev;
  Node({this.data, this.next, this.prev});
}

class MiniSubscription<T> {
  const MiniSubscription(
      this.data, this.onError, this.onDone, this.cancelOnError, this.listener);
  final OnData<T> data;
  final Function? onError;
  final Callback? onDone;
  final bool cancelOnError;

  Future<void> cancel() async => listener.removeListener(this);

  final FastList<T> listener;
}

class MiniStream<T> {
  FastList<T> listenable = FastList<T>();

  late T _value;

  T get value => _value;

  set value(T val) {
    add(val);
  }

  void add(T event) {
    _value = event;
    listenable._notifyData(event);
  }

  void addError(Object error, [StackTrace? stackTrace]) {
    listenable._notifyError(error, stackTrace);
  }

  int get length => listenable.length;

  bool get hasListeners => listenable.isNotEmpty;

  bool get isClosed => _isClosed;

  MiniSubscription<T> listen(void Function(T event) onData,
      {Function? onError,
      void Function()? onDone,
      bool cancelOnError = false}) {
    final subs = MiniSubscription<T>(
      onData,
      onError,
      onDone,
      cancelOnError,
      listenable,
    );
    listenable.addListener(subs);
    return subs;
  }

  bool _isClosed = false;

  void close() {
    if (_isClosed) {
      throw 'You can not close a closed Stream';
    }
    listenable._notifyDone();
    listenable.clear();
    _isClosed = true;
  }
}

class FastList<T> {
  Node<MiniSubscription<T>>? _head;
  Node<MiniSubscription<T>>? _tail;
  int _length = 0;

  void _notifyData(T data) {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.data(data);
      currentNode = currentNode.next;
    }
  }

  void _notifyDone() {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.onDone?.call();
      currentNode = currentNode.next;
    }
  }

  void _notifyError(Object error, [StackTrace? stackTrace]) {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.onError?.call(error, stackTrace);
      currentNode = currentNode.next;
    }
  }

  bool get isEmpty => _length == 0;

  bool get isNotEmpty => _length > 0;

  int get length => _length;

  MiniSubscription<T>? elementAt(int position) {
    if (isEmpty || position < 0 || position >= _length) return null;

    var node = _head;
    var current = 0;

    while (current != position) {
      node = node!.next;
      current++;
    }
    return node!.data;
  }

  void addListener(MiniSubscription<T> data) {
    var newNode = Node(data: data);

    if (isEmpty) {
      _head = _tail = newNode;
    } else {
      _tail!.next = newNode;
      newNode.prev = _tail;
      _tail = newNode;
    }
    _length++;
  }

  bool contains(T element) {
    var currentNode = _head;
    while (currentNode != null) {
      if (currentNode.data == element) return true;
      currentNode = currentNode.next;
    }
    return false;
  }

  void removeListener(MiniSubscription<T> element) {
    var currentNode = _head;
    while (currentNode != null) {
      if (currentNode.data == element) {
        _removeNode(currentNode);
        break;
      }
      currentNode = currentNode.next;
    }
  }

  void clear() {
    _head = _tail = null;
    _length = 0;
  }

  void _removeNode(Node<MiniSubscription<T>> node) {
    if (node.prev == null) {
      _head = node.next;
    } else {
      node.prev!.next = node.next;
    }

    if (node.next == null) {
      _tail = node.prev;
    } else {
      node.next!.prev = node.prev;
    }

    _length--;
  }
}
