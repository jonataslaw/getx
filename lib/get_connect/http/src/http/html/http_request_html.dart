import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' show XHRGetters, XMLHttpRequest;

import '../../certificates/certificates.dart';
import '../../exceptions/exceptions.dart';
import '../../request/request.dart';
import '../../response/response.dart';
import '../interface/request_base.dart';
import '../utils/body_decoder.dart';

class HttpRequestImpl implements IClient {
  HttpRequestImpl({
    bool allowAutoSignedCert = true,
    List<TrustedCertificate>? trustedCertificates,
    this.withCredentials = false,
    String Function(Uri url)? findProxy,
  });

  final _xhrs = <XMLHttpRequest>{};
  final bool withCredentials;

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    if (_isClosed) {
      throw GetHttpException(
          'HTTP request failed. Client is already closed.', request.url);
    }

    var bytes = await request.bodyBytes.toBytes();
    XMLHttpRequest xhr = XMLHttpRequest();

    xhr
      ..timeout = (timeout ?? Duration.zero).inMilliseconds
      ..open(request.method, '${request.url}', true);

    _xhrs.add(xhr);

    xhr
      ..responseType = 'arraybuffer' // Changed from 'blob' to 'arraybuffer'
      ..withCredentials = withCredentials;

    request.headers.forEach((key, value) => xhr.setRequestHeader(key, value));

    var completer = Completer<Response<T>>();

    unawaited(xhr.onLoad.first.then((_) async {
      final bodyBytes =
          (xhr.response as JSArrayBuffer).toDart.asUint8List().toStream();

      if (request.responseInterceptor != null) {
        throw GetHttpException(
            'Response interception not implemented for web yet!', request.url);
      }

      final stringBody =
          await bodyBytesToString(bodyBytes, xhr.responseHeaders);
      final contentType =
          xhr.responseHeaders['content-type'] ?? 'application/json';

      final body = bodyDecoded<T>(request, stringBody, contentType);

      final response = Response<T>(
        bodyBytes: bodyBytes,
        statusCode: xhr.status,
        request: request,
        headers: xhr.responseHeaders,
        statusText: xhr.statusText,
        body: body,
        bodyString: stringBody,
      );

      completer.complete(response);
    }));

    unawaited(xhr.onError.first.then((_) {
      completer.completeError(
        GetHttpException('XMLHttpRequest error.', request.url),
        StackTrace.current,
      );
    }));

    xhr.send(bytes.toJS);

    try {
      return await completer.future;
    } finally {
      _xhrs.remove(xhr);
    }
  }

  @override
  void close() {
    _isClosed = true;
    for (var xhr in _xhrs) {
      xhr.abort();
    }
    _xhrs.clear();
  }

  @override
  Duration? timeout;
  bool _isClosed = false;
}

extension on XMLHttpRequest {
  Map<String, String> get responseHeaders {
    var headers = <String, String>{};
    var headersString = getAllResponseHeaders();
    var headersList = headersString.split('\r\n');
    for (var header in headersList) {
      if (header.isEmpty) continue;

      var splitIdx = header.indexOf(': ');
      if (splitIdx == -1) continue;

      var key = header.substring(0, splitIdx).toLowerCase();
      var value = header.substring(splitIdx + 2);
      if (headers.containsKey(key)) {
        headers[key] = '${headers[key]}, $value';
      } else {
        headers[key] = value;
      }
    }
    return headers;
  }
}
