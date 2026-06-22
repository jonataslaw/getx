import './socket_notifier.dart';

class BaseWebSocket {
  String url;
  Duration ping;
  bool allowSelfSigned;
  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  }) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  Future connect() async {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void onOpen(OpenSocket fn) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void onClose(CloseSocket fn) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void onError(CloseSocket fn) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void onMessage(MessageSocket fn) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void on(String event, MessageSocket message) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void close([int? status, String? reason]) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void send(dynamic data) async {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void dispose() {
    throw Exception('To use sockets you need dart:io or dart:html');
  }

  void emit(String event, dynamic data) {
    throw Exception('To use sockets you need dart:io or dart:html');
  }
}
