import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../../../get_core/get_core.dart';
import 'socket_notifier.dart';

class BaseWebSocket {

  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  });
  String url;
  WebSocket? socket;
  SocketNotifier? socketNotifier = SocketNotifier();
  bool isDisposed = false;
  Duration ping;
  bool allowSelfSigned;
  ConnectionStatus? connectionStatus;

  void close([final int? status, final String? reason]) {
    socket?.close(status, reason);
  }

  // ignore: use_setters_to_change_properties
  Future connect() async {
    if (isDisposed) {
      socketNotifier = SocketNotifier();
    }
    try {
      connectionStatus = ConnectionStatus.connecting;
      socket = allowSelfSigned
          ? await _connectForSelfSignedCert(url)
          : await WebSocket.connect(url);

      socket!.pingInterval = ping;
      socketNotifier?.open();
      connectionStatus = ConnectionStatus.connected;

      socket!.listen((final data) {
        socketNotifier!.notifyData(data);
      }, onError: (final err) {
        socketNotifier!.notifyError(Close(err.toString(), 1005));
      }, onDone: () {
        connectionStatus = ConnectionStatus.closed;
        socketNotifier!
            .notifyClose(Close('Connection Closed', socket!.closeCode));
      }, cancelOnError: true,);
      return;
    } on SocketException catch (e) {
      connectionStatus = ConnectionStatus.closed;
      socketNotifier!
          .notifyError(Close(e.osError!.message, e.osError!.errorCode));
      return;
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

  void send(final dynamic data) async {
    if (connectionStatus == ConnectionStatus.closed) {
      await connect();
    }

    if (socket != null) {
      socket!.add(data);
    }
  }

  Future<WebSocket> _connectForSelfSignedCert(final String url) async {
    try {
      final r = Random();
      final key = base64.encode(List<int>.generate(8, (final _) => r.nextInt(255)));
      final client = HttpClient(context: SecurityContext());
      client.badCertificateCallback = (final cert, final host, final port) {
        Get.log(
            'BaseWebSocket: Allow self-signed certificate => $host:$port. ',);
        return true;
      };

      final request = await client.getUrl(Uri.parse(url))
        ..headers.add('Connection', 'Upgrade')
        ..headers.add('Upgrade', 'websocket')
        ..headers.add('Cache-Control', 'no-cache')
        ..headers.add('Sec-WebSocket-Version', '13')
        ..headers.add('Sec-WebSocket-Key', key.toLowerCase());

      final response = await request.close();
      // ignore: close_sinks
      final socket = await response.detachSocket();
      final webSocket = WebSocket.fromUpgradedSocket(
        socket,
        serverSide: false,
      );

      return webSocket;
    } on Exception catch (_) {
      rethrow;
    }
  }
}

enum ConnectionStatus {
  connecting,
  connected,
  closed,
}
