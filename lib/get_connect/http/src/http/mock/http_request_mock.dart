import 'dart:typed_data';

import '../../request/request.dart';
import '../../response/response.dart';
import '../interface/request_base.dart';
import '../utils/body_decoder.dart';

typedef MockClientHandler = Future<Response> Function(Request request);

class MockClient extends IClient {
  /// Creates a [MockClient] with a handler that receives [Request]s and sends
  /// [Response]s.
  MockClient(this._handler);

  /// The handler for than transforms request on response
  final MockClientHandler _handler;

  @override
  Future<Response<T>> send<T>(final Request<T> request) async {
    final Uint8List requestBody = await request.bodyBytes.toBytes();
    final Stream<List<int>> bodyBytes = requestBody.toStream();

    final Response response = await _handler(request);

    final String stringBody =
        await bodyBytesToString(bodyBytes, response.headers!);

    final String? mimeType = response.headers!.containsKey('content-type')
        ? response.headers!['content-type']
        : '';

    final body = bodyDecoded<T>(
      request,
      stringBody,
      mimeType,
    );
    return Response(
      headers: response.headers,
      request: request,
      statusCode: response.statusCode,
      statusText: response.statusText,
      bodyBytes: bodyBytes,
      body: body,
      bodyString: stringBody,
    );
  }

  @override
  void close() {}
}
