import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import '../../../get_core/get_core.dart';

import 'socket_notifier.dart';

enum ConnectionStatus {
  connecting,
  connected,
  closed,
}

class BaseWebSocket {
  String url;
  WebSocket socket;
  SocketNotifier socketNotifier = SocketNotifier();
  Duration ping;
  bool isDisposed = false;
  bool allowSelfSigned;

  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  }) {
    url = url.startsWith('https')
        ? url.replaceAll('https:', 'wss:')
        : url.replaceAll('http:', 'ws:');
  }
  ConnectionStatus connectionStatus;
  Timer _t;

  void connect() {
    try {
      connectionStatus = ConnectionStatus.connecting;
      socket = WebSocket(url);
      socket.onOpen.listen((e) {
        socketNotifier?.open();
        _t = Timer?.periodic(ping, (t) {
          socket.send('');
        });
        connectionStatus = ConnectionStatus.connected;
      });

      socket.onMessage.listen((event) {
        socketNotifier.notifyData(event.data);
      });

      socket.onClose.listen((e) {
        _t?.cancel();

        connectionStatus = ConnectionStatus.closed;
        socketNotifier.notifyClose(Close(e.reason, e.code));
      });
      socket.onError.listen((event) {
        _t?.cancel();
        socketNotifier.notifyError(Close(event.toString(), 0));
        connectionStatus = ConnectionStatus.closed;
      });
    } on Exception catch (e) {
      _t?.cancel();
      socketNotifier.notifyError(Close(e.toString(), 500));
      connectionStatus = ConnectionStatus.closed;
      //  close(500, e.toString());
    }
  }

  // ignore: use_setters_to_change_properties
  void onOpen(OpenSocket fn) {
    socketNotifier.open = fn;
  }

  void onClose(CloseSocket fn) {
    socketNotifier.addCloses(fn);
  }

  void onError(CloseSocket fn) {
    socketNotifier.addErrors(fn);
  }

  void onMessage(MessageSocket fn) {
    socketNotifier.addMessages(fn);
  }

  void on(String event, MessageSocket message) {
    socketNotifier.addEvents(event, message);
  }

  void close([int status, String reason]) {
    if (socket != null) socket.close(status, reason);
  }

  void send(dynamic data) {
    if (connectionStatus == ConnectionStatus.closed) {
      connect();
    }
    if (socket != null && socket.readyState == WebSocket.OPEN) {
      socket.send(data);
    } else {
      Get.log('WebSocket not connected, message $data not sent');
    }
  }

  void emit(String event, dynamic data) {
    send(jsonEncode({'type': event, 'data': data}));
  }

  void dispose() {
    socketNotifier.dispose();
    socketNotifier = null;
    isDisposed = true;
  }
}
