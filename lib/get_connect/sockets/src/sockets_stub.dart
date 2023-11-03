import './socket_notifier.dart';

class BaseWebSocket {
  BaseWebSocket(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  }) {
    throw 'To use sockets you need dart:io or dart:html';
  }
  String url;
  Duration ping;
  bool allowSelfSigned;

  Future connect() async {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onOpen(final OpenSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onClose(final CloseSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onError(final CloseSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void onMessage(final MessageSocket fn) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void on(final String event, final MessageSocket message) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void close([final int? status, final String? reason]) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void send(final dynamic data) async {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void dispose() {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void emit(final String event, final dynamic data) {
    throw 'To use sockets you need dart:io or dart:html';
  }
}
