import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/http.dart';
import 'package:get/get_connect/http/src/http/interface/request_base.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class _UnauthorizedClient implements IClient {
  @override
  Duration? timeout;
  @override
  Future<Response<T>> send<T>(Request<T> request) async =>
      Response<T>(request: request, statusCode: 401);
  @override
  void close() {}
}

void main() {
  test('errorSafety handles asynchronous authenticator failure during retry',
      () async {
    final client = GetHttpClient(customClient: _UnauthorizedClient());
    addTearDown(client.close);
    client.addAuthenticator<dynamic>((request) async {
      throw Exception('authentication failed');
    });
    final response = await client.get<dynamic>('https://example.invalid');
    expect(response.statusCode, isNull);
    expect(response.statusText, contains('authentication failed'));
  });
}
