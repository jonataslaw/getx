class BaseWebSocket {
  String url;
  Duration ping;
  BaseWebSocket(this.url, {this.ping = const Duration(seconds: 5)}) {
    throw 'To use sockets you need dart:io or dart:html';
  }

  void close([int status, String reason]) {
    throw 'To use sockets you need dart:io or dart:html';
  }
}
