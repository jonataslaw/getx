@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:get/get_connect/http/src/http.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

void main() {
  late io.HttpServer server;
  late GetHttpClient client;
  late String origin;
  late Future<void> Function(io.HttpRequest) handle;

  setUp(() async {
    server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    origin = 'http://${server.address.address}:${server.port}';
    client = GetHttpClient(timeout: const Duration(seconds: 2));
    handle = (request) async {
      request.response.statusCode = 404;
      await request.response.close();
    };
    server.listen((request) async {
      try {
        await handle(request);
      } on io.SocketException {
        // Timeout/close tests deliberately disconnect the client.
      } on io.HttpException {
        // Writing after a deliberate disconnect may fail on the server.
      }
    });
  });

  tearDown(() async {
    client.close();
    await server.close(force: true);
  });

  Future<void> jsonResponse(io.HttpRequest request, Object body,
      {int status = 200}) async {
    request.response.statusCode = status;
    request.response.headers.contentType = io.ContentType.json;
    request.response.write(jsonEncode(body));
    await request.response.close();
  }

  test('real GET preserves query, headers, decoder and modifier order',
      () async {
    final order = <String>[];
    handle = (request) async {
      expect(request.method, 'GET');
      expect(request.uri.path, '/items');
      expect(request.uri.queryParameters['search'], 'a+b & فارسی');
      expect(request.headers.value('x-request'), 'sent');
      request.response.headers.set('x-response', 'received');
      await jsonResponse(request, {'value': 7});
    };
    client.addRequestModifier<int>((request) {
      order.add('request');
      request.headers['x-request'] = 'sent';
      return request as Request<int>;
    });
    client.addResponseModifier<int>((request, response) {
      order.add('response');
      return Response<int>(
        request: request,
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body! + 1,
      );
    });
    final response = await client.get<int>(
      '$origin/items',
      query: {'search': 'a+b & فارسی'},
      decoder: (data) {
        order.add('decoder');
        return (data as Map<String, dynamic>)['value'] as int;
      },
    );
    expect(response.statusCode, 200);
    expect(response.body, 8);
    expect(response.headers!['x-response'], 'received');
    expect(order, ['request', 'decoder', 'response']);
  });

  for (final status in [404, 500]) {
    test('real HTTP $status keeps response status and decoded error body',
        () async {
      client.errorSafety = false;
      handle = (request) =>
          jsonResponse(request, {'error': 'rejected'}, status: status);
      final response = await client.get<Map<String, dynamic>>('$origin/error');
      expect(response.statusCode, status);
      expect(response.hasError, isTrue);
      expect(response.body, {'error': 'rejected'});
    });
  }

  test('real unauthorized request retries once with authenticator headers',
      () async {
    var attempts = 0;
    var authCalls = 0;
    handle = (request) async {
      attempts++;
      final authorized =
          request.headers.value('authorization') == 'Bearer local';
      await jsonResponse(request, {'authorized': authorized},
          status: authorized ? 200 : 401);
    };
    client.addAuthenticator<Map<String, dynamic>>((request) async {
      authCalls++;
      return (request as Request<Map<String, dynamic>>).copyWith(
        headers: {...request.headers, 'authorization': 'Bearer local'},
      );
    });
    final response = await client.get<Map<String, dynamic>>('$origin/auth');
    expect(response.statusCode, 200);
    expect(response.body, {'authorized': true});
    expect(attempts, 2);
    expect(authCalls, 1);
  });

  test('unauthorized retries are bounded by maxAuthRetries', () async {
    var attempts = 0;
    var authCalls = 0;
    client.maxAuthRetries = 2;
    handle = (request) async {
      attempts++;
      await jsonResponse(request, {'error': 'unauthorized'}, status: 401);
    };
    client.addAuthenticator<dynamic>((request) {
      authCalls++;
      return request;
    });
    final response = await client.get<dynamic>('$origin/auth');
    expect(response.statusCode, 401);
    expect(attempts, 3);
    expect(authCalls, 2);
  });

  test('POST JSON and URL-encoded bodies preserve UTF-8 and content length',
      () async {
    handle = (request) async {
      final bytes =
          await request.fold<List<int>>([], (all, part) => all..addAll(part));
      await jsonResponse(request, {
        'method': request.method,
        'body': utf8.decode(bytes),
        'type': request.headers.contentType!.mimeType,
        'length': request.contentLength,
        'received': bytes.length,
      });
    };
    final json = await client
        .post<Map<String, dynamic>>('$origin/body', body: {'text': 'سلام + &'});
    expect(json.body!['method'], 'POST');
    expect(jsonDecode(json.body!['body'] as String), {'text': 'سلام + &'});
    expect(json.body!['length'], json.body!['received']);
    final form = await client.post<Map<String, dynamic>>(
      '$origin/body',
      body: {'text': 'سلام + &'},
      contentType: 'application/x-www-form-urlencoded',
    );
    expect(Uri.splitQueryString(form.body!['body'] as String),
        {'text': 'سلام + &'});
    expect(form.body!['type'], 'application/x-www-form-urlencoded');
    expect(form.body!['length'], form.body!['received']);
  });

  test('multipart transmits fields and binary file with matching length',
      () async {
    final form = FormData({
      'label': 'سلام',
      'tags': ['first', 'second'],
      'file': MultipartFile([0, 1, 127, 255], filename: 'payload.bin'),
    });
    handle = (request) async {
      final bytes =
          await request.fold<List<int>>([], (all, part) => all..addAll(part));
      final parts =
          latin1.decode(bytes).split('--${form.boundary}').sublist(1, 5);
      final bodies = <List<int>>[];
      for (final part in parts) {
        final separator = part.indexOf('\r\n\r\n');
        expect(separator, greaterThan(0));
        bodies
            .add(latin1.encode(part.substring(separator + 4, part.length - 2)));
      }
      expect(request.headers.contentType!.mimeType, 'multipart/form-data');
      expect(request.contentLength, bytes.length);
      expect(bytes.length, form.length);
      expect(parts.last, contains('filename="payload.bin"'));
      expect(bodies, [
        utf8.encode('سلام'),
        utf8.encode('first'),
        utf8.encode('second'),
        [0, 1, 127, 255]
      ]);
      await jsonResponse(request, {'parts': parts.length});
    };
    final response =
        await client.post<Map<String, dynamic>>('$origin/upload', body: form);
    expect(response.statusCode, 200);
    expect(response.body, {'parts': 4});
  });

  for (final safe in [true, false]) {
    test('response-header timeout honors errorSafety=$safe', () async {
      client.timeout = const Duration(milliseconds: 100);
      client.errorSafety = safe;
      final received = Completer<void>();
      final release = Completer<void>();
      addTearDown(() {
        if (!release.isCompleted) release.complete();
      });
      handle = (request) async {
        received.complete();
        await release.future;
        await request.response.close();
      };
      final future = client.get<dynamic>('$origin/slow');
      if (safe) {
        final response = await future.timeout(const Duration(seconds: 3));
        expect(response.statusCode, isNull);
        expect(response.statusText, contains('TimeoutException'));
      } else {
        await expectLater(
            future.timeout(const Duration(seconds: 3)),
            throwsA(isA<GetHttpException>().having(
                (e) => e.message, 'message', contains('TimeoutException'))));
      }
      expect(received.isCompleted, isTrue);
    });
  }

  test('timeout also bounds a stalled response body after headers arrive',
      () async {
    client.timeout = const Duration(milliseconds: 100);
    final release = Completer<void>();
    addTearDown(() {
      if (!release.isCompleted) release.complete();
    });
    handle = (request) async {
      request.response.headers.contentType = io.ContentType.text;
      request.response.write('prefix');
      await request.response.flush();
      await release.future;
      await request.response.close();
    };
    final response = await client
        .get<String>('$origin/stalled-body')
        .timeout(const Duration(seconds: 3));
    expect(response.statusCode, isNull);
    expect(response.statusText, contains('TimeoutException'));
  });

  test('closing client aborts an in-flight transport request', () async {
    final received = Completer<void>();
    final release = Completer<void>();
    addTearDown(() {
      if (!release.isCompleted) release.complete();
    });
    handle = (request) async {
      received.complete();
      await release.future;
      await request.response.close();
    };
    final pending = client.get<dynamic>('$origin/pending');
    await received.future.timeout(const Duration(seconds: 3));
    client.close();
    final response = await pending.timeout(const Duration(seconds: 3));
    expect(response.statusCode, isNull);
    expect(response.status.connectionError, isTrue);
  });
}
