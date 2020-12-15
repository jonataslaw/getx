import './socket_notifier.dart';

class BaseWebSocket {
  String url;
  Duration ping;
  bool allowSelfSigned;
  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    allowSelfSigned = true,
  }) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  Future connect() async {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onOpen(OpenSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onClose(CloseSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onError(CloseSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onMessage(MessageSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void on(String event, MessageSocket message) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void close([int status, String reason]) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void send(dynamic data) async {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void dispose() {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void emit(String event, dynamic data) {
    throw 'To use sockets you need dart:io or dart:html';
  }
}
