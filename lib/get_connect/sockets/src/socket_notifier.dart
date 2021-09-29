import 'dart:convert';

class Close {
  final String? message;
  final int? reason;

  Close(this.message, this.reason);

  @override
  String toString() {
    return 'Closed by server [$reason => $message]!';
  }
}

typedef OpenSocket = void Function();

typedef CloseSocket = void Function(Close);

typedef MessageSocket = void Function(dynamic val);

class SocketNotifier {
  List<void Function(dynamic)>? _onMessages = <MessageSocket>[];
  Map<String, void Function(dynamic)>? _onEvents = <String, MessageSocket>{};
  List<void Function(Close)>? _onCloses = <CloseSocket>[];
  List<void Function(Close)>? _onErrors = <CloseSocket>[];

  late OpenSocket open;

  void addMessages(MessageSocket socket) {
    _onMessages!.add((socket));
  }

  void addEvents(String event, MessageSocket socket) {
    _onEvents![event] = socket;
  }

  void addCloses(CloseSocket socket) {
    _onCloses!.add(socket);
  }

  void addErrors(CloseSocket socket) {
    _onErrors!.add((socket));
  }

  void notifyData(dynamic data) {
    for (var item in _onMessages!) {
      item(data);
    }
    if (data is String) {
      _tryOn(data);
    }
  }

  void notifyClose(Close err) {
    for (var item in _onCloses!) {
      item(err);
    }
  }

  void notifyError(Close err) {
    // rooms.removeWhere((key, value) => value.contains(_ws));
    for (var item in _onErrors!) {
      item(err);
    }
  }

  void _tryOn(String message) {
    try {
      var msg = jsonDecode(message);
      final event = msg['type'];
      final data = msg['data'];
      if (_onEvents!.containsKey(event)) {
        _onEvents![event]!(data);
      }
    } catch (_) {
      return;
    }
  }

  void dispose() {
    _onMessages = null;
    _onEvents = null;
    _onCloses = null;
    _onErrors = null;
  }
}
