import 'dart:async';
import 'dart:io' as io;

import '../../certificates/certificates.dart';
import '../../exceptions/exceptions.dart';
import '../../request/request.dart';
import '../../response/response.dart';
import '../interface/request_base.dart';
import '../utils/body_decoder.dart';

/// A `dart:io` implementation of `HttpRequestBase`.
class HttpRequestImpl extends HttpRequestBase {
  io.HttpClient _httpClient;
  io.SecurityContext _securityContext;

  HttpRequestImpl({
    bool allowAutoSignedCert = true,
    List<TrustedCertificate> trustedCertificates,
  }) {
    _httpClient = io.HttpClient();
    if (trustedCertificates != null) {
      _securityContext = io.SecurityContext();
      for (final trustedCertificate in trustedCertificates) {
        _securityContext
            .setTrustedCertificatesBytes(List.from(trustedCertificate.bytes));
      }
    }

    _httpClient = io.HttpClient(context: _securityContext);
    _httpClient.badCertificateCallback = (_, __, ___) => allowAutoSignedCert;
  }

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    var stream = request.bodyBytes.asBroadcastStream();
    //var stream = BodyBytesStream.fromBytes(requestBody ?? const []);

    try {
      var ioRequest = (await _httpClient.openUrl(request.method, request.url))
        ..followRedirects = request.followRedirects
        ..persistentConnection = request.persistentConnection
        ..maxRedirects = request.maxRedirects
        ..contentLength = request.contentLength ?? -1;
      request.headers.forEach(ioRequest.headers.set);

      var response = await stream.pipe(ioRequest) as io.HttpClientResponse;

      var headers = <String, String>{};
      response.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });

      final bodyBytes = BodyBytesStream(response);
      final stringBody = await bodyBytesToString(bodyBytes, headers);

      final body = bodyDecoded<T>(
        request,
        stringBody,
        response.headers.contentType.mimeType,
      );

      return Response(
        headers: headers,
        request: request,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
        bodyBytes: bodyBytes,
        body: body,
        bodyString: stringBody,
      );
    } on io.HttpException catch (error) {
      throw GetHttpException(error.message, error.uri);
    }
  }

  /// Closes the HttpClient.
  @override
  void close() {
    if (_httpClient != null) {
      _httpClient.close(force: true);
      _httpClient = null;
    }
  }
}

// extension FileExt on io.FileSystemEntity {
//   String get fileName {
//     return this?.path?.split(io.Platform.pathSeparator)?.last;
//   }
// }
