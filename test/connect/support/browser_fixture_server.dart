import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Serves loopback HTTP/WebSocket fixtures for the browser transport tests.
Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final sockets = <WebSocket>[];
  final stats = <String, Map<String, dynamic>>{};
  stdout.writeln(jsonEncode({'origin': 'http://127.0.0.1:${server.port}'}));
  await for (final request in server) {
    unawaited(() async {
      final response = request.response;
      response.headers
        ..set('access-control-allow-origin', '*')
        ..set('access-control-allow-methods', 'GET, POST, OPTIONS')
        ..set('access-control-allow-headers',
            'content-type, authorization, x-test')
        ..set('access-control-expose-headers', 'x-fixture');
      if (request.method == 'OPTIONS') {
        response.statusCode = 204;
        await response.close();
        return;
      }
      final id = request.uri.queryParameters['id'] ?? 'default';
      final state = stats.putIfAbsent(
          id,
          () => {
                'connections': 0,
                'closes': 0,
                'messages': <String>[],
                'binary': <List<int>>[],
              });
      try {
        if (request.uri.path == '/socket') {
          final socket = await WebSocketTransformer.upgrade(request);
          sockets.add(socket);
          state['connections'] = (state['connections'] as int) + 1;
          socket.listen((message) {
            if (message is String) {
              (state['messages'] as List<String>).add(message);
            } else if (message is List<int>) {
              (state['binary'] as List<List<int>>).add(message);
            }
            socket.add(message);
          }, onDone: () {
            state['closes'] = (state['closes'] as int) + 1;
            sockets.remove(socket);
          });
          return;
        }
        if (request.uri.path == '/close-socket') {
          for (final socket in sockets.toList()) {
            await socket.close(WebSocketStatus.normalClosure, 'fixture close');
          }
        }
        if (request.uri.path == '/slow') {
          await Future<void>.delayed(const Duration(milliseconds: 600));
        }
        response.headers.contentType = ContentType.json;
        response.headers.set('x-fixture', 'loopback');
        if (request.uri.path == '/status') {
          response.statusCode = int.parse(request.uri.queryParameters['code']!);
        }
        if (request.uri.path == '/auth' &&
            request.headers.value('authorization') != 'Bearer local') {
          response.statusCode = 401;
        }
        if (request.uri.path == '/upload') {
          final bytes = await request
              .fold<List<int>>([], (all, next) => all..addAll(next));
          response.write(jsonEncode({
            'data': base64Encode(bytes),
            'type': request.headers.contentType.toString(),
            'received': bytes.length,
          }));
          await response.close();
          return;
        }
        final body = request.uri.path == '/stats'
            ? state
            : {
                'value': 7,
                'path': request.uri.path,
                'query': request.uri.queryParameters['query'],
                'header': request.headers.value('x-test'),
                'authorization': request.headers.value('authorization'),
                'body': await utf8.decoder.bind(request).join(),
              };
        response.write(jsonEncode(body));
        await response.close();
      } on SocketException {
        // Aborting a request or closing a socket is exercised deliberately.
      } on HttpException {
        // The peer may close its transport before a delayed response is sent.
      }
    }());
  }
}
