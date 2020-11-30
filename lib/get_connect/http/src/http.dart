import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../src/certificates/certificates.dart';
import '../src/exceptions/exceptions.dart';
import '../src/http_impl/http_request_stub.dart'
    if (dart.library.html) 'http_impl/http_request_html.dart'
    if (dart.library.io) 'http_impl/http_request_io.dart';
import '../src/http_impl/request_base.dart';
import '../src/multipart/form_data.dart';
import '../src/request/request.dart';
import '../src/response/response.dart';
import '../src/status/http_status.dart';
import 'interceptors/get_modifiers.dart';

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

  bool errorSafety = true;

  final HttpRequestBase _httpClient;

  final GetModifier _modifier;

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
        _modifier = GetModifier();

  void addAuthenticator<T>(RequestModifier<T> auth) {
    _modifier.authenticator = auth as RequestModifier;
  }

  void addRequestModifier<T>(RequestModifier<T> interceptor) {
    _modifier.addRequestModifier<T>(interceptor);
  }

  void removeRequestModifier<T>(RequestModifier<T> interceptor) {
    _modifier.removeRequestModifier(interceptor);
  }

  void addResponseModifier<T>(ResponseModifier<T> interceptor) {
    _modifier.addResponseModifier(interceptor);
  }

  void removeResponseModifier<T>(ResponseModifier<T> interceptor) {
    _modifier.removeResponseModifier<T>(interceptor);
  }

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
    List<int> bodyBytes;
    BodyBytes bodyStream;
    final headers = <String, String>{};
    headers['content-type'] = contentType ?? defaultContentType;
    headers['user-agent'] = userAgent;

    if (body is FormData) {
      bodyBytes = await body.toBytes();
      headers['content-length'] = bodyBytes.length.toString();
    } else if (body is Map || body is List) {
      var jsonString = json.encode(body);

      //TODO check this implementation
      if (contentType != null) {
        if (contentType.toLowerCase() == 'application/x-www-form-urlencoded') {
          var paramName = 'param';
          jsonString = '$paramName=${Uri.encodeQueryComponent(jsonString)}';
        }
      }

      bodyBytes = utf8.encode(jsonString);
      headers['content-length'] = bodyBytes.length.toString();
    } else if (body == null) {
      headers['content-length'] = '0';
    } else {
      if (!errorSafety) {
        throw UnexpectedFormat('body cannot be ${body.runtimeType}');
      }
    }

    if (bodyBytes != null) {
      bodyStream = BodyBytes.fromBytes(bodyBytes);
    }

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

      if (authenticate) await _modifier.authenticator(request);
      await _modifier.modifyRequest(request);

      var response = await _httpClient.send<T>(request);

      await _modifier.modifyResponse(request, response);

      if (HttpStatus.unauthorized == response.statusCode &&
          _modifier.authenticator != null &&
          requestNumber <= maxAuthRetries) {
        return _performRequest(
          handler,
          authenticate: true,
          requestNumber: requestNumber + 1,
          headers: request.headers,
        );
      } else if (HttpStatus.unauthorized == response.statusCode) {
        if (!errorSafety) {
          throw UnauthorizedException();
        } else {
          return Response<T>(
            request: request,
            headers: response.headers,
            statusCode: response.statusCode,
            body: response.body,
            statusText: response.statusText,
          );
        }
      }

      return response;
    } on Exception catch (err) {
      if (!errorSafety) {
        throw GetHttpException(err.toString());
      } else {
        return Response<T>(
          request: null,
          headers: null,
          statusCode: null,
          body: null,
          statusText: "$err",
        );
      }
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
  }) {
    return _requestWithBody<T>(
      url,
      contentType,
      body,
      'post',
      query,
      decoder,
    );
  }

  Future<Request<T>> _request<T>(
    String url,
    String method, {
    String contentType,
    @required dynamic body,
    @required Map<String, dynamic> query,
    Decoder<T> decoder,
  }) {
    return _requestWithBody(url, contentType, body, method, query, decoder);
  }

  Future<Request<T>> _put<T>(
    String url, {
    String contentType,
    @required dynamic body,
    @required Map<String, dynamic> query,
    Decoder<T> decoder,
  }) {
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
    String url, {
    dynamic body,
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
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        request: null,
        statusCode: null,
        body: null,
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> request<T>(
    String url,
    String method, {
    dynamic body,
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  }) async {
    try {
      var response = await _performRequest(
        () => _request(
          url,
          method,
          contentType: contentType,
          query: query,
          body: body,
          decoder: decoder,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        request: null,
        statusCode: null,
        body: null,
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> put<T>(
    String url, {
    dynamic body,
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
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
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
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
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
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
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
