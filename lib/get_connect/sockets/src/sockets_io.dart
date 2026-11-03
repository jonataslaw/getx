import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../get_core/get_core.dart';
import 'socket_notifier.dart';

class BaseWebSocket {
  String url;
  WebSocket? socket;
  SocketNotifier? socketNotifier = SocketNotifier();
  bool isDisposed = false;
  Duration ping;
  bool allowSelfSigned;
  ConnectionStatus? connectionStatus;
  int _generation = 0;
  Future<void>? _connecting;

  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  });

  void close([int? status, String? reason]) {
    socket?.close(status, reason);
  }

  // ignore: use_setters_to_change_properties
  Future<void> connect() {
    final pending = _connecting;
    if (pending != null) return pending;
    late final Future<void> connecting;
    connecting = _connect().whenComplete(() {
      if (identical(_connecting, connecting)) _connecting = null;
    });
    _connecting = connecting;
    return connecting;
  }

  Future<void> _connect() async {
    if (isDisposed) {
      socketNotifier = SocketNotifier();
      isDisposed = false;
    }
    final generation = ++_generation;
    try {
      connectionStatus = ConnectionStatus.connecting;
      final connected = allowSelfSigned
          ? await _connectForSelfSignedCert(url)
          : await WebSocket.connect(url);
      if (isDisposed || generation != _generation) {
        await connected.close();
        return;
      }
      socket = connected;
      connected.pingInterval = ping;
      connectionStatus = ConnectionStatus.connected;
      connected.listen((data) {
        if (generation == _generation) socketNotifier?.notifyData(data);
      }, onError: (Object err) {
        if (generation == _generation) {
          socketNotifier?.notifyError(Close(err.toString(), 1005));
        }
      }, onDone: () {
        if (generation != _generation) return;
        connectionStatus = ConnectionStatus.closed;
        socketNotifier
            ?.notifyClose(Close('Connection Closed', connected.closeCode));
      }, cancelOnError: true);
      socketNotifier?.open();
    } on SocketException catch (e) {
      if (generation != _generation) return;
      connectionStatus = ConnectionStatus.closed;
      socketNotifier?.notifyError(
          Close(e.osError?.message ?? e.message, e.osError?.errorCode));
    }
  }

  void dispose() {
    if (isDisposed) return;
    isDisposed = true;
    _generation++;
    _connecting = null;
    connectionStatus = ConnectionStatus.closed;
    socket?.close();
    socket = null;
    socketNotifier?.dispose();
    socketNotifier = null;
  }

  void emit(String event, dynamic data) {
    send(jsonEncode({'type': event, 'data': data}));
  }

  void on(String event, MessageSocket message) {
    socketNotifier!.addEvents(event, message);
  }

  void onClose(CloseSocket fn) {
    socketNotifier!.addCloses(fn);
  }

  void onError(CloseSocket fn) {
    socketNotifier!.addErrors(fn);
  }

  void onMessage(MessageSocket fn) {
    socketNotifier!.addMessages(fn);
  }

  // ignore: use_setters_to_change_properties
  void onOpen(OpenSocket fn) {
    socketNotifier!.open = fn;
  }

  void send(dynamic data) async {
    if (isDisposed) return;
    if (connectionStatus == ConnectionStatus.closed || _connecting != null) {
      await connect();
    }

    if (!isDisposed && connectionStatus == ConnectionStatus.connected) {
      socket?.add(data);
    }
  }

  Future<WebSocket> _connectForSelfSignedCert(String url) async {
    final client = HttpClient(context: SecurityContext());
    client.badCertificateCallback = (cert, host, port) {
      Get.log('BaseWebSocket: Allow self-signed certificate => $host:$port. ');
      return true;
    };
    try {
      return await WebSocket.connect(url, customClient: client);
    } finally {
      client.close();
    }
  }
}

enum ConnectionStatus {
  connecting,
  connected,
  closed,
}
