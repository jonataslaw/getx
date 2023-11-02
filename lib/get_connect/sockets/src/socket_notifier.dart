import 'dart:convert';

/// Signature for [SocketNotifier.addCloses].
typedef CloseSocket = void Function(Close);

/// Signature for [SocketNotifier.addMessages].
typedef MessageSocket = void Function(dynamic val);

/// Signature for [SocketNotifier.open].
typedef OpenSocket = void Function();

/// Wrapper class to message and reason from SocketNotifier
class Close {

  Close(this.message, this.reason);
  final String? message;
  final int? reason;

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
  void addCloses(final CloseSocket socket) {
    _onCloses!.add(socket);
  }

  /// subscribe to error events
  void addErrors(final CloseSocket socket) {
    _onErrors!.add(socket);
  }

  /// subscribe to named events
  void addEvents(final String event, final MessageSocket socket) {
    _onEvents![event] = socket;
  }

  /// subscribe to message events
  void addMessages(final MessageSocket socket) {
    _onMessages!.add(socket);
  }

  /// Dispose messages, events, closes and errors subscriptions
  void dispose() {
    _onMessages = null;
    _onEvents = null;
    _onCloses = null;
    _onErrors = null;
  }

  /// Notify all subscriptions on [addCloses]
  void notifyClose(final Close err) {
    for (final item in _onCloses!) {
      item(err);
    }
  }

  /// Notify all subscriptions on [addMessages]
  void notifyData(final dynamic data) {
    for (final item in _onMessages!) {
      item(data);
    }
    if (data is String) {
      _tryOn(data);
    }
  }

  /// Notify all subscriptions on [addErrors]
  void notifyError(final Close err) {
    // rooms.removeWhere((key, value) => value.contains(_ws));
    for (final item in _onErrors!) {
      item(err);
    }
  }

  void _tryOn(final String message) {
    try {
      final msg = jsonDecode(message);
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
