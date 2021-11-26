import 'dart:convert';

/// Signature for [SocketNotifier.addCloses].
typedef CloseSocket = void Function(Close);

/// Signature for [SocketNotifier.addMessages].
typedef MessageSocket = void Function(dynamic val);

/// Signature for [SocketNotifier.open].
typedef OpenSocket = void Function();

/// Wrapper class to message and reason from SocketNotifier
class Close {
  final String? message;
  final int? reason;

  Close(this.message, this.reason);

  @override
  String toString() {
    return 'Closed by server [$reason => $message]!';
  }
}

/// This class manages the transmission of messages over websockets using
/// GetConnect
class SocketNotifier {
  List<void Function(dynamic)>? _onMessages = <MessageSocket>[];
  Map<String, void Function(dynamic)>? _onEvents = <String, MessageSocket>{};
  List<void Function(Close)>? _onCloses = <CloseSocket>[];
  List<void Function(Close)>? _onErrors = <CloseSocket>[];

  late OpenSocket open;

  /// subscribe to close events
  void addCloses(CloseSocket socket) {
    _onCloses!.add(socket);
  }

  /// subscribe to error events
  void addErrors(CloseSocket socket) {
    _onErrors!.add((socket));
  }

  /// subscribe to named events
  void addEvents(String event, MessageSocket socket) {
    _onEvents![event] = socket;
  }

  /// subscribe to message events
  void addMessages(MessageSocket socket) {
    _onMessages!.add((socket));
  }

  /// Dispose messages, events, closes and errors subscriptions
  void dispose() {
    _onMessages = null;
    _onEvents = null;
    _onCloses = null;
    _onErrors = null;
  }

  /// Notify all subscriptions on [addCloses]
  void notifyClose(Close err) {
    for (var item in _onCloses!) {
      item(err);
    }
  }

  /// Notify all subscriptions on [addMessages]
  void notifyData(dynamic data) {
    for (var item in _onMessages!) {
      item(data);
    }
    if (data is String) {
      _tryOn(data);
    }
  }

  /// Notify all subscriptions on [addErrors]
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
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return;
    }
  }
}
