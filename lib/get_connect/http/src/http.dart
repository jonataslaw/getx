import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../src/certificates/certificates.dart';
import '../src/exceptions/exceptions.dart';
import '../src/http_impl/http_request_stub.dart'
    if (dart.library.html) 'http_impl/http_request_html.dart'
    if (dart.library.io) 'http_impl/http_request_io.dart';
import '../src/http_impl/request_base.dart';
import '../src/interceptors/get_interceptors.dart';
import '../src/multipart/form_data.dart';
import '../src/request/request.dart';
import '../src/response/response.dart';
import '../src/status/http_status.dart';

typedef Decoder<T> = T Function(dynamic data);

class GetHttpClient {
  String userAgent;
  String baseUrl;

  String defaultContentType = 'application/json; charset=utf-8';

  bool followRedirects;
  int maxRedirects;
  int maxAuthRetries;

  Decoder defaultDecoder;

  Duration timeout;

  final HttpRequestBase _httpClient;

  final GetModifier _interceptor;

  GetHttpClient({
    this.userAgent = 'getx-client',
    this.timeout = const Duration(seconds: 8),
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.maxAuthRetries = 1,
    bool allowAutoSignedCert = false,
    this.baseUrl,
    List<TrustedCertificate> trustedCertificates,
  })  : _httpClient = HttpRequestImpl(
          allowAutoSignedCert: allowAutoSignedCert,
          trustedCertificates: trustedCertificates,
        ),
        _interceptor = GetModifier();

  Uri _createUri(String url, Map<String, dynamic> query) {
    if (baseUrl != null) {
      url = baseUrl + url;
    }
    final uri = Uri.parse(url);
    if (query != null) {
      uri.replace(queryParameters: query);
    }
    return uri;
  }

  Future<Request<T>> _requestWithBody<T>(
    String url,
    String contentType,
    dynamic body,
    String method,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  ) async {
    assert(method != null);
    assert(body != null);

    List<int> bodyBytes;

    if (body is FormData) {
      bodyBytes = await body.readAsBytes();
    } else {
      try {
        var jsonString = json.encode(body);

        //TODO check this implementation
        if (contentType != null) {
          if (contentType.toLowerCase() ==
              'application/x-www-form-urlencoded') {
            var paramName = 'param';
            jsonString = '$paramName=${Uri.encodeQueryComponent(jsonString)}';
          }
        }

        bodyBytes = utf8.encode(jsonString);
      } on Exception catch (err) {
        throw UnexpectedFormat(err.toString());
      }
    }

    final bodyStream = BodyBytes.fromBytes(bodyBytes);

    final headers = <String, String>{};

    _setHeadersWithBody(contentType, headers, bodyBytes);

    final uri = _createUri(url, query);

    return Request(
      method: method,
      url: uri,
      headers: headers,
      bodyBytes: bodyStream,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
    );
  }

  void _setHeadersWithBody(
    String contentType,
    // String jsonString,
    Map<String, String> headers,
    List<int> bodyBytes,
    // List<MultipartFile> files,
  ) {
    // if (files != null) {
    //   headers['content-type'] = 'multipart/form-data';
    //   headers['x-requested-with'] = 'XMLHttpRequest';
    // } else {
    //   headers['content-type'] = contentType ?? defaultContentType;
    // }

    headers['content-type'] =
        contentType ?? defaultContentType; // verify if this is better location

    headers['user-agent'] = userAgent;
    headers['content-length'] = bodyBytes.length.toString();
  }

  void _setSimpleHeaders(
    Map<String, String> headers,
    String contentType,
  ) {
    headers['content-type'] = contentType ?? defaultContentType;
    headers['user-agent'] = userAgent;
  }

  Future<Response<T>> _performRequest<T>(
    HandlerExecute<T> handler, {
    bool authenticate = false,
    int requestNumber = 1,
    Map<String, String> headers,
  }) async {
    try {
      var request = await handler();

      headers?.forEach((key, value) {
        request.headers[key] = value;
      });

      if (authenticate) await _interceptor.authenticator(request);
      await _interceptor.modifyRequest(request);

      var response = await _httpClient.send<T>(request);

      await _interceptor.modifyResponse(request, response);

      if (HttpStatus.unauthorized == response.statusCode &&
          _interceptor.authenticator != null &&
          requestNumber <= maxAuthRetries) {
        return _performRequest(
          handler,
          authenticate: true,
          requestNumber: requestNumber + 1,
          headers: request.headers,
        );
      } else if (HttpStatus.unauthorized == response.statusCode) {
        throw UnauthorizedException();
      }

      return response;
    } on Exception catch (err) {
      throw GetHttpException(err.toString());
    }
  }

  Future<Request<T>> _get<T>(
    String url,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  ) {
    final headers = <String, String>{};
    _setSimpleHeaders(headers, contentType);
    final uri = _createUri(url, query);

    return Future.value(Request<T>(
      method: 'get',
      url: uri,
      headers: headers,
      decoder: decoder ?? (defaultDecoder as Decoder<T>),
    ));
  }

  Future<Request<T>> _post<T>(
    String url, {
    String contentType,
    @required dynamic body,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    // List<MultipartFile> files,
  }) {
    assert(body != null);
    return _requestWithBody<T>(
      url,
      contentType,
      body,
      'post',
      query,
      decoder,
    );
  }

  Future<Request<T>> _put<T>(
    String url, {
    String contentType,
    @required dynamic body,
    @required Map<String, dynamic> query,
    Decoder<T> decoder,
    //  List<MultipartFile> files,
  }) {
    assert(body != null);
    return _requestWithBody(url, contentType, body, 'put', query, decoder);
  }

  Request<T> _delete<T>(
    String url,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  ) {
    final headers = <String, String>{};
    _setSimpleHeaders(headers, contentType);
    final uri = _createUri(url, query);

    return Request<T>(
        method: 'delete', url: uri, headers: headers, decoder: decoder);
  }

  Future<Response<T>> post<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    // List<MultipartFile> files,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _post<T>(
          url,
          contentType: contentType,
          body: body,
          query: query,
          decoder: decoder,
          //  files: files,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      return Future.value(Response<T>(
        request: null,
        statusCode: null,
        body: null,
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> put<T>(
    String url,
    Map<String, dynamic> body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  }) async {
    try {
      var response = await _performRequest(
        () => _put(
          url,
          contentType: contentType,
          query: query,
          body: body,
          decoder: decoder,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      return Future.value(Response<T>(
        request: null,
        statusCode: null,
        body: null,
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, String> headers,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _get<T>(url, contentType, query, decoder),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      return Future.value(Response<T>(
        request: null,
        statusCode: null,
        body: null,
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String> headers,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  }) async {
    try {
      var response = await _performRequest(
        () async => _delete<T>(url, contentType, query, decoder),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      return Future.value(Response<T>(
        request: null,
        statusCode: null,
        body: null,
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  void close() {
    _httpClient.close();
  }
}
