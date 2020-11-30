import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import '../certificates/certificates.dart';
import '../exceptions/exceptions.dart';
import '../request/request.dart';
import '../response/response.dart';
import 'request_base.dart';

/// A `dart:html` implementation of `HttpRequestBase`.
class HttpRequestImpl implements HttpRequestBase {
  HttpRequestImpl({
    bool allowAutoSignedCert = true,
    List<TrustedCertificate> trustedCertificates,
  });

  /// The currently active XHRs.
  final _xhrs = <html.HttpRequest>{};

  ///This option requires that you submit credentials for requests
  ///on different sites. The default is false
  bool withCredentials = false;

  /// Sends an HTTP request and asynchronously returns the response.
  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    var bytes = await request.bodyBytes.toBytes();
    html.HttpRequest xhr;

    // if (request.files != null) {
    //   var data = html.FormData();
    //   if (request.files != null) {
    //     for (MultipartFile element in request.files) {
    //       var stream = element.finalize();
    //       data.appendBlob(element., html.File(element.finalize(),
    // element.filename),
    //           element.filename);
    //     }
    //   }

    //   xhr = await html.HttpRequest.request('${request.url}',
    //       method: request.method, sendData: data);
    // } else {
    //   xhr = html.HttpRequest()
    //     ..open(request.method, '${request.url}', async: true);
    // }

    xhr = html.HttpRequest()
      ..open(request.method, '${request.url}', async: true); // check this

    _xhrs.add(xhr);

    xhr
      ..responseType = 'blob'
      ..withCredentials = withCredentials;
    request.headers.forEach(xhr.setRequestHeader);

    var completer = Completer<Response<T>>();
    xhr.onLoad.first.then((_) {
      var blob = xhr.response as html.Blob ?? html.Blob([]);
      var reader = html.FileReader();

      reader.onLoad.first.then((_) async {
        var bodyBytes = BodyBytes.fromBytes(reader.result as Uint8List);

        final stringBody =
            await bodyBytesToString(bodyBytes, xhr.responseHeaders);

        T body;
        try {
          if (request.decoder == null) {
            body = jsonDecode(stringBody) as T;
          } else {
            body = request.decoder(jsonDecode(stringBody));
          }
          // body = request.decoder(stringBody);
        } on Exception catch (_) {
          body = stringBody as T;
        }

        // final body = jsonDecode(stringBody);

        final response = Response<T>(
          bodyBytes: bodyBytes,
          statusCode: xhr.status,
          request: request,
          headers: xhr.responseHeaders,
          statusText: xhr.statusText,
          body: body,
        );
        completer.complete(response);
      });

      reader.onError.first.then((error) {
        completer.completeError(
          GetHttpException(error.toString(), request.url),
          StackTrace.current,
        );
      });

      reader.readAsArrayBuffer(blob);
    });

    xhr.onError.first.then((_) {
      completer.completeError(
          GetHttpException('XMLHttpRequest error.', request.url),
          StackTrace.current);
    });

    xhr.send(bytes);

    try {
      return await completer.future;
    } finally {
      _xhrs.remove(xhr);
    }
  }

  /// Closes the client and abort all active requests.
  @override
  void close() {
    for (var xhr in _xhrs) {
      xhr.abort();
    }
  }
}
