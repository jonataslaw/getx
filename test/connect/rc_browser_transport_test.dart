@TestOn('browser')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/http.dart';
import 'package:get/get_connect/http/src/http/html/http_request_html.dart'
    as browser_http;
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/sockets/sockets.dart';

const _origin = String.fromEnvironment('GETX_BROWSER_FIXTURE');

void main() {
  setUpAll(() {
    if (!_origin.startsWith('http://127.0.0.1:')) {
      throw StateError('Start test/connect/support/browser_fixture_server.dart '
          'and supply --dart-define=GETX_BROWSER_FIXTURE=<its origin>.');
    }
  });

  late GetHttpClient client;
  setUp(() => client = GetHttpClient(timeout: const Duration(seconds: 2)));
  tearDown(() => client.close());

  test('browser HTTP preserves real query, typed decoder and modifier result',
      () async {
    client.addRequestModifier<int>((request) {
      request.headers['x-test'] = 'browser';
      return request as Request<int>;
    });
    client.addResponseModifier<int>((request, response) => Response<int>(
          body: response.body! + 1,
          headers: response.headers,
          statusCode: response.statusCode,
          request: request,
        ));
    final response = await client.get<int>(
      '$_origin/echo',
      query: {'query': 'a+b & فارسی'},
      decoder: (data) {
        expect(data['query'], 'a+b & فارسی');
        expect(data['header'], 'browser');
        return data['value'] as int;
      },
    ).timeout(const Duration(seconds: 3));
    expect(response.statusCode, 200);
    expect(response.headers!['x-fixture'], 'loopback');
    expect(response.body, 8);
  });

  test('browser typed authenticator retries with replacement request',
      () async {
    var attempts = 0;
    client.addAuthenticator<Map<String, dynamic>>((request) {
      attempts++;
      return (request as Request<Map<String, dynamic>>).copyWith(
        headers: {...request.headers, 'authorization': 'Bearer local'},
      );
    });
    final response = await client
        .get<Map<String, dynamic>>('$_origin/auth')
        .timeout(const Duration(seconds: 3));
    expect(response.statusCode, 200);
    expect(response.body!['authorization'], 'Bearer local');
    expect(attempts, 1);
  });

  test('browser HTTP error status retains decoded body', () async {
    final response = await client.get<Map<String, dynamic>>(
      '$_origin/status',
      query: {'code': '500'},
    ).timeout(const Duration(seconds: 3));
    expect(response.statusCode, 500);
    expect(response.hasError, isTrue);
    expect(response.body!['value'], 7);
  });

  test('browser multipart upload retains Unicode fields and binary bytes',
      () async {
    final form = FormData({
      'label': 'سلام',
      'file': MultipartFile([0, 127, 255], filename: 'browser.bin'),
    });
    final response = await client
        .post<Map<String, dynamic>>('$_origin/upload', body: form)
        .timeout(const Duration(seconds: 3));
    expect(response.statusCode, 200);
    expect(response.body!['type'], contains('multipart/form-data'));
    final bytes = base64Decode(response.body!['data'] as String);
    final wire = latin1.decode(bytes);
    expect(bytes.length, form.length);
    expect(response.body!['received'], bytes.length);
    expect(wire, contains('filename="browser.bin"'));
    expect(wire, contains(latin1.decode(utf8.encode('سلام'))));
    expect(wire, contains(latin1.decode([0, 127, 255])));
  });

  test('browser timeout completes the request rather than hanging', () async {
    client.timeout = const Duration(milliseconds: 100);
    final response = await client
        .get<dynamic>('$_origin/slow')
        .timeout(const Duration(seconds: 2));
    expect(response.statusCode, isNull);
    expect(response.statusText!.toLowerCase(), contains('timeout'));
  });

  test('browser client.close completes an aborted request', () async {
    final pending = client.get<dynamic>('$_origin/slow');
    await Future<void>.delayed(const Duration(milliseconds: 75));
    client.close();
    final response = await pending.timeout(const Duration(seconds: 2));
    expect(response.statusCode, isNull);
    expect(response.statusText!.toLowerCase(), contains('abort'));
  });

  test('browser close during body preparation prevents a later request',
      () async {
    final started = Completer<void>();
    final body = StreamController<List<int>>(onListen: started.complete);
    final transport = browser_http.HttpRequestImpl();
    final pending = transport.send<dynamic>(Request<dynamic>(
      url: Uri.parse('$_origin/echo'),
      method: 'POST',
      headers: {},
      bodyBytes: body.stream,
    ));
    await started.future.timeout(const Duration(seconds: 2));
    transport.close();
    body.add([1, 2, 3]);
    await body.close();
    await expectLater(
        pending.timeout(const Duration(seconds: 2)),
        throwsA(isA<GetHttpException>().having(
            (error) => error.message, 'message', contains('already closed'))));
  });

  test(
      'browser decoder errors complete the returned future without a zone leak',
      () async {
    await expectLater(
        client.get<int>('$_origin/echo', decoder: (_) {
          throw StateError('decoder rejected data');
        }).timeout(const Duration(seconds: 2)),
        throwsA(isA<StateError>().having(
            (error) => error.message, 'message', 'decoder rejected data')));
  });

  test(
      'unsupported browser response interception completes through errorSafety',
      () async {
    final response = await client
        .get<dynamic>(
          '$_origin/echo',
          responseInterceptor: (request, type, response) async => null,
        )
        .timeout(const Duration(seconds: 2));
    expect(response.statusCode, isNull);
    expect(response.statusText, contains('not implemented for web'));
  });

  Future<Map<String, dynamic>> stats(String id) async {
    final response = await client
        .get<Map<String, dynamic>>('$_origin/stats', query: {'id': id});
    return response.body!;
  }

  String fixtureId(String name) =>
      '$name-${DateTime.now().microsecondsSinceEpoch}';

  test('browser socket sends text and named event payloads without boxing',
      () async {
    final id = fixtureId('text');
    final socket =
        GetSocket('$_origin/socket?id=$id', ping: const Duration(seconds: 10));
    addTearDown(socket.dispose);
    final opened = Completer<void>();
    final text = Completer<dynamic>();
    final event = Completer<dynamic>();
    socket.onOpen(opened.complete);
    socket.onMessage((message) {
      if (!text.isCompleted) text.complete(message);
    });
    socket.on('answer', event.complete);
    socket.connect();
    await opened.future.timeout(const Duration(seconds: 3));
    socket.send('hello');
    expect(await text.future.timeout(const Duration(seconds: 3)), 'hello');
    socket.emit('answer', {'value': 42});
    expect(
        await event.future.timeout(const Duration(seconds: 3)), {'value': 42});
    expect((await stats(id))['messages'],
        ['hello', '{"type":"answer","data":{"value":42}}']);
  });

  test('browser socket preserves binary messages', () async {
    final id = fixtureId('binary');
    final socket =
        GetSocket('$_origin/socket?id=$id', ping: const Duration(seconds: 10));
    addTearDown(socket.dispose);
    final opened = Completer<void>();
    final received = Completer<dynamic>();
    socket.onOpen(opened.complete);
    socket.onMessage(received.complete);
    socket.connect();
    await opened.future.timeout(const Duration(seconds: 3));
    socket.send(Uint8List.fromList([0, 127, 255]));
    expect(await received.future.timeout(const Duration(seconds: 3)),
        [0, 127, 255]);
    expect((await stats(id))['binary'], [
      [0, 127, 255]
    ]);
  });

  test('browser reconnect retains messages sent during the handshake',
      () async {
    final id = fixtureId('reconnect');
    final socket =
        GetSocket('$_origin/socket?id=$id', ping: const Duration(seconds: 10));
    addTearDown(socket.dispose);
    final opened = Completer<void>();
    final closed = Completer<void>();
    final both = Completer<void>();
    final received = <dynamic>[];
    var opens = 0;
    socket.onOpen(() {
      opens++;
      if (!opened.isCompleted) opened.complete();
    });
    socket.onClose((_) {
      if (!closed.isCompleted) closed.complete();
    });
    socket.onMessage((message) {
      received.add(message);
      if (received.length == 2) both.complete();
    });
    socket.connect();
    await opened.future.timeout(const Duration(seconds: 3));
    await client.get<dynamic>('$_origin/close-socket');
    await closed.future.timeout(const Duration(seconds: 3));
    socket.send('one');
    socket.send('two');
    await both.future.timeout(const Duration(seconds: 2));
    expect(received, ['one', 'two']);
    expect(opens, 2);
    expect((await stats(id))['connections'], 2);
  });

  test('manual browser reconnect closes the previous live transport', () async {
    final id = fixtureId('manual');
    final socket =
        GetSocket('$_origin/socket?id=$id', ping: const Duration(seconds: 10));
    addTearDown(socket.dispose);
    final first = Completer<void>();
    final second = Completer<void>();
    var opens = 0;
    socket.onOpen(() {
      opens++;
      if (opens == 1) first.complete();
      if (opens == 2) second.complete();
    });
    socket.connect();
    await first.future.timeout(const Duration(seconds: 3));
    socket.connect();
    await second.future.timeout(const Duration(seconds: 3));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final snapshot = await stats(id);
    expect(snapshot['connections'], 2);
    expect(snapshot['closes'], 1);
  });

  test('browser dispose stops transport and heartbeat, and is idempotent',
      () async {
    final id = fixtureId('dispose');
    final socket = GetSocket('$_origin/socket?id=$id',
        ping: const Duration(milliseconds: 30));
    final opened = Completer<void>();
    socket.onOpen(opened.complete);
    socket.connect();
    await opened.future.timeout(const Duration(seconds: 3));
    socket.dispose();
    socket.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final snapshot = await stats(id);
    expect(snapshot['closes'], 1);
    expect(snapshot['messages'], isEmpty);
  });
}
