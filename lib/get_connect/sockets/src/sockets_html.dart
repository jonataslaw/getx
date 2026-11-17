import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as html;

import '../../../get_core/get_core.dart';
import 'socket_notifier.dart';

class BaseWebSocket {
  String url;
  html.WebSocket? socket;
  SocketNotifier? socketNotifier = SocketNotifier();
  Duration ping;
  bool isDisposed = false;
  bool allowSelfSigned;

  ConnectionStatus? connectionStatus;
  Timer? _t;
  int _generation = 0;
  final _pendingMessages = <Object>[];
  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  }) {
    url = url.startsWith('https')
        ? url.replaceAll('https:', 'wss:')
        : url.replaceAll('http:', 'ws:');
  }

  void close([int? status, String? reason]) {
    // This weird code is fault of web package, they are not using null safety yet
    // See https://github.com/dart-lang/web/blob/main/web/lib/src/dom/websockets.dart#L60
    if (status != null && reason != null) {
      socket?.close(status, reason);
    } else if (status != null) {
      socket?.close(status);
    } else {
      socket?.close();
    }
  }

  // ignore: use_setters_to_change_properties
  void connect() {
    if (isDisposed) {
      socketNotifier = SocketNotifier();
      isDisposed = false;
    }
    final generation = ++_generation;
    _t?.cancel();
    _t = null;
    socket?.close();
    socket = null;
    try {
      connectionStatus = ConnectionStatus.connecting;
      final connected = html.WebSocket(url)..binaryType = 'arraybuffer';
      socket = connected;
      connected.onOpen.listen((_) {
        if (generation != _generation || isDisposed) {
          connected.close();
          return;
        }
        connectionStatus = ConnectionStatus.connected;
        final pending = _pendingMessages.toList();
        _pendingMessages.clear();
        for (final message in pending) {
          _sendData(connected, message);
        }
        socketNotifier?.open();
        if (generation != _generation || isDisposed) return;
        _t?.cancel();
        _t = Timer.periodic(ping, (timer) {
          if (generation != _generation ||
              connected.readyState != html.WebSocket.OPEN) {
            timer.cancel();
            return;
          }
          connected.send(''.toJS);
        });
      });
      connected.onMessage.listen((event) {
        if (generation != _generation || isDisposed) return;
        final data = event.data;
        if (data != null && data.isA<JSArrayBuffer>()) {
          socketNotifier
              ?.notifyData((data as JSArrayBuffer).toDart.asUint8List());
        } else {
          socketNotifier?.notifyData(data.dartify());
        }
      });
      connected.onClose.listen((event) {
        if (generation != _generation) return;
        _t?.cancel();
        connectionStatus = ConnectionStatus.closed;
        socketNotifier?.notifyClose(Close(event.reason, event.code));
      });
      connected.onError.listen((event) {
        if (generation != _generation) return;
        _t?.cancel();
        connectionStatus = ConnectionStatus.closed;
        socketNotifier?.notifyError(Close(event.toString(), 0));
      });
    } on Exception catch (error) {
      if (generation != _generation) return;
      _t?.cancel();
      connectionStatus = ConnectionStatus.closed;
      socketNotifier?.notifyError(Close(error.toString(), 500));
    }
  }

  void dispose() {
    if (isDisposed) return;
    isDisposed = true;
    _generation++;
    _t?.cancel();
    _t = null;
    socket?.close();
    socket = null;
    connectionStatus = ConnectionStatus.closed;
    _pendingMessages.clear();
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

  void send(Object data) {
    if (isDisposed) return;
    if (connectionStatus == ConnectionStatus.closed ||
        connectionStatus == ConnectionStatus.connecting) {
      _pendingMessages.add(data);
      if (connectionStatus == ConnectionStatus.closed) connect();
      return;
    }
    final connected = socket;
    if (connected != null && connected.readyState == html.WebSocket.OPEN) {
      _sendData(connected, data);
    } else {
      Get.log('WebSocket not connected, message $data not sent');
    }
  }

  void _sendData(html.WebSocket connected, Object data) {
    if (data is String) {
      connected.send(data.toJS);
    } else if (data is Uint8List) {
      connected.send(data.toJS);
    } else if (data is ByteBuffer) {
      connected.send(data.toJS);
    } else if (data is List<int>) {
      connected.send(Uint8List.fromList(data).toJS);
    } else {
      throw ArgumentError.value(data, 'data', 'Expected text or binary bytes');
    }
  }
}

enum ConnectionStatus {
  connecting,
  connected,
  closed,
}
