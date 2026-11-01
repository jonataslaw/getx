import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/http.dart';
import 'package:get/get_connect/http/src/http/interface/request_base.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class _TestClient implements IClient {
  @override
  Duration? timeout;

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    return Response<T>(
      request: request,
      statusCode: 200,
      statusText: 'original',
    );
  }

  @override
  void close() {}
}

void main() {
  late GetHttpClient client;

  setUp(() {
    client = GetHttpClient(customClient: _TestClient());
  });

  tearDown(() => client.close());

  group('GetHttpClient.removeResponseModifier', () {
    for (final asynchronous in [false, true]) {
      test('removes a ${asynchronous ? 'future-returning' : 'synchronous'} '
          'response modifier after it has run', () async {
        var calls = 0;
        FutureOr<Response<dynamic>> modifier(
          Request<dynamic> request,
          Response<dynamic> response,
        ) {
          calls++;
          final modified = Response<String>(
            request: request,
            statusCode: 200,
            statusText: 'modified',
          );
          return asynchronous ? Future.value(modified) : modified;
        }

        client.addResponseModifier(modifier);
        final before = await client.get('https://example.com');
        expect(before.statusText, 'modified');
        expect(calls, 1);

        client.removeResponseModifier(modifier);
        final after = await client.get('https://example.com');
        expect(after.statusText, 'original');
        expect(calls, 1);
      });
    }

    test('preserves other response modifiers and request modifiers', () async {
      final calls = <String>[];
      client.addRequestModifier<dynamic>((request) {
        calls.add('request');
        request.headers['x-test'] = 'preserved';
        return request;
      });
      client.addResponseModifier((request, response) {
        calls.add('first');
        return response;
      });
      Response<dynamic> removed(
        Request<dynamic> request,
        Response<dynamic> response,
      ) {
        calls.add('removed');
        return response;
      }

      client.addResponseModifier(removed);
      client.addResponseModifier((request, response) {
        calls.add('last');
        return response;
      });
      client.removeResponseModifier(removed);

      final response = await client.get('https://example.com');
      expect(response.statusCode, 200);
      expect(response.request!.headers['x-test'], 'preserved');
      expect(calls, ['request', 'first', 'last']);
    });

    test(
      'removing an unknown modifier or removing twice is harmless',
      () async {
        var keptCalls = 0;
        var removedCalls = 0;
        client.addResponseModifier((request, response) {
          keptCalls++;
          return response;
        });
        Response<dynamic> removed(
          Request<dynamic> request,
          Response<dynamic> response,
        ) {
          removedCalls++;
          return response;
        }

        client.removeResponseModifier(removed);
        client.addResponseModifier(removed);
        client.removeResponseModifier(removed);
        client.removeResponseModifier(removed);

        final response = await client.get('https://example.com');
        expect(response.statusCode, 200);
        expect(keptCalls, 1);
        expect(removedCalls, 0);
      },
    );

    test(
      'can register a removed modifier again without duplicate calls',
      () async {
        var calls = 0;
        Response<dynamic> modifier(
          Request<dynamic> request,
          Response<dynamic> response,
        ) {
          calls++;
          return response;
        }

        client.addResponseModifier(modifier);
        client.removeResponseModifier(modifier);
        client.addResponseModifier(modifier);

        final response = await client.get('https://example.com');
        expect(response.statusCode, 200);
        expect(calls, 1);
      },
    );
  });
}
