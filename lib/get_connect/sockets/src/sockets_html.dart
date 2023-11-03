import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import '../../../get_core/get_core.dart';
import 'socket_notifier.dart';

class BaseWebSocket {
  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  }) {
    url = url.startsWith('https')
        ? url.replaceAll('https:', 'wss:')
        : url.replaceAll('http:', 'ws:');
  }
  String url;
  WebSocket? socket;
  SocketNotifier? socketNotifier = SocketNotifier();
  Duration ping;
  bool isDisposed = false;
  bool allowSelfSigned;

  ConnectionStatus? connectionStatus;
  Timer? _t;

  void close([final int? status, final String? reason]) {
    socket?.close(status, reason);
  }

  // ignore: use_setters_to_change_properties
  void connect() {
    try {
      connectionStatus = ConnectionStatus.connecting;
      socket = WebSocket(url);
      socket!.onOpen.listen((final e) {
        socketNotifier?.open();
        _t = Timer?.periodic(ping, (final t) {
          socket!.send('');
        });
        connectionStatus = ConnectionStatus.connected;
      });

      socket!.onMessage.listen((final event) {
        socketNotifier!.notifyData(event.data);
      });

      socket!.onClose.listen((final e) {
        _t?.cancel();

        connectionStatus = ConnectionStatus.closed;
        socketNotifier!.notifyClose(Close(e.reason, e.code));
      });
      socket!.onError.listen((final event) {
        _t?.cancel();
        socketNotifier!.notifyError(Close(event.toString(), 0));
        connectionStatus = ConnectionStatus.closed;
      });
    } on Exception catch (e) {
      _t?.cancel();
      socketNotifier!.notifyError(Close(e.toString(), 500));
      connectionStatus = ConnectionStatus.closed;
      //  close(500, e.toString());
    }
  }

  void dispose() {
    socketNotifier!.dispose();
    socketNotifier = null;
    isDisposed = true;
  }

  void emit(final String event, final dynamic data) {
    send(jsonEncode({'type': event, 'data': data}));
  }

  void on(final String event, final MessageSocket message) {
    socketNotifier!.addEvents(event, message);
  }

  void onClose(final CloseSocket fn) {
    socketNotifier!.addCloses(fn);
  }

  void onError(final CloseSocket fn) {
    socketNotifier!.addErrors(fn);
  }

  void onMessage(final MessageSocket fn) {
    socketNotifier!.addMessages(fn);
  }

  // ignore: use_setters_to_change_properties
  void onOpen(final OpenSocket fn) {
    socketNotifier!.open = fn;
  }

  void send(final dynamic data) {
    if (connectionStatus == ConnectionStatus.closed) {
      connect();
    }
    if (socket != null && socket!.readyState == WebSocket.OPEN) {
      socket!.send(data);
    } else {
      Get.log('WebSocket not connected, message $data not sent');
    }
  }
}

enum ConnectionStatus {
  connecting,
  connected,
  closed,
}
