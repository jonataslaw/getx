import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../src/certificates/certificates.dart';
import '../src/exceptions/exceptions.dart';
import '../src/multipart/form_data.dart';
import '../src/request/request.dart';
import '../src/response/response.dart';
import '../src/status/http_status.dart';
import 'http/interface/request_base.dart';
import 'http/request/http_request.dart';
import 'interceptors/get_modifiers.dart';

typedef Decoder<T> = T Function(dynamic data);

typedef Progress = Function(double percent);

typedef ResponseInterceptor<T> = Future<Response<T>?> Function(
    Request<T> request, Type targetType, HttpClientResponse response);

class GetHttpClient {
  String userAgent;
  String? baseUrl;

  String defaultContentType = 'application/json; charset=utf-8';

  bool followRedirects;
  int maxRedirects;
  int maxAuthRetries;

  bool sendUserAgent;
  bool sendContentLength;

  Decoder? defaultDecoder;
  ResponseInterceptor? defaultResponseInterceptor;

  Duration timeout;

  bool errorSafety = true;

  final IClient _httpClient;

  final GetModifier _modifier;

  String Function(Uri url)? findProxy;

  GetHttpClient({
    this.userAgent = 'getx-client',
    this.timeout = const Duration(seconds: 8),
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.sendUserAgent = false,
    this.sendContentLength = true,
    this.maxAuthRetries = 1,
    bool allowAutoSignedCert = false,
    this.baseUrl,
    List<TrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    String Function(Uri url)? findProxy,
    IClient? customClient,
  })  : _httpClient = customClient ??
            createHttp(
              allowAutoSignedCert: allowAutoSignedCert,
              trustedCertificates: trustedCertificates,
              withCredentials: withCredentials,
              findProxy: findProxy,
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

  Uri createUri(String? url, Map<String, dynamic>? query) {
    if (baseUrl != null) {
      url = baseUrl! + url!;
    }
    final uri = Uri.parse(url!);
    if (query != null) {
      return uri.replace(queryParameters: query);
    }
    return uri;
  }

  Future<Request<T>> _requestWithBody<T>(
    String? url,
    String? contentType,
    dynamic body,
    String method,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  ) async {
    List<int>? bodyBytes;
    Stream<List<int>>? bodyStream;
    final headers = <String, String>{};

    if (sendUserAgent) {
      headers['user-agent'] = userAgent;
    }

    if (body is FormData) {
      bodyBytes = await body.toBytes();
      headers['content-length'] = bodyBytes.length.toString();
      headers['content-type'] =
          'multipart/form-data; boundary=${body.boundary}';
    } else if (contentType != null &&
        contentType.toLowerCase() == 'application/x-www-form-urlencoded' &&
        body is Map) {
      var parts = [];
      (body as Map<String, dynamic>).forEach((key, value) {
        parts.add('${Uri.encodeQueryComponent(key)}='
            '${Uri.encodeQueryComponent(value.toString())}');
      });
      var formData = parts.join('&');
      bodyBytes = utf8.encode(formData);
      _setContentLenght(headers, bodyBytes.length);
      headers['content-type'] = contentType;
    } else if (body is Map || body is List) {
      var jsonString = json.encode(body);
      bodyBytes = utf8.encode(jsonString);
      _setContentLenght(headers, bodyBytes.length);
      headers['content-type'] = contentType ?? defaultContentType;
    } else if (body is String) {
      bodyBytes = utf8.encode(body);
      _setContentLenght(headers, bodyBytes.length);

      headers['content-type'] = contentType ?? defaultContentType;
    } else if (body == null) {
      _setContentLenght(headers, 0);
      headers['content-type'] = contentType ?? defaultContentType;
    } else {
      if (!errorSafety) {
        throw UnexpectedFormat('body cannot be ${body.runtimeType}');
      }
    }

    if (bodyBytes != null) {
      bodyStream = _trackProgress(bodyBytes, uploadProgress);
    }

    final uri = createUri(url, query);
    return Request<T>(
        method: method,
        url: uri,
        headers: headers,
        bodyBytes: bodyStream,
        contentLength: bodyBytes?.length ?? 0,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        decoder: decoder,
        responseInterceptor: responseInterceptor);
  }

  void _setContentLenght(Map<String, String> headers, int contentLength) {
    if (sendContentLength) {
      headers['content-length'] = '$contentLength';
    }
  }

  Stream<List<int>> _trackProgress(
    List<int> bodyBytes,
    Progress? uploadProgress,
  ) {
    var total = 0;
    var length = bodyBytes.length;

    var byteStream =
        Stream.fromIterable(bodyBytes.map((i) => [i])).transform<List<int>>(
      StreamTransformer.fromHandlers(handleData: (data, sink) {
        total += data.length;
        if (uploadProgress != null) {
          var percent = total / length * 100;
          uploadProgress(percent);
        }
        sink.add(data);
      }),
    );
    return byteStream;
  }

  void _setSimpleHeaders(
    Map<String, String> headers,
    String? contentType,
  ) {
    headers['content-type'] = contentType ?? defaultContentType;
    if (sendUserAgent) {
      headers['user-agent'] = userAgent;
    }
  }

  Future<Response<T>> _performRequest<T>(
    HandlerExecute<T> handler, {
    bool authenticate = false,
    int requestNumber = 1,
    Map<String, String>? headers,
  }) async {
    var request = await handler();

    headers?.forEach((key, value) {
      request.headers[key] = value;
    });

    if (authenticate) await _modifier.authenticator!(request);
    final newRequest = await _modifier.modifyRequest<T>(request);

    _httpClient.timeout = timeout;
    try {
      var response = await _httpClient.send<T>(newRequest);

      final newResponse =
          await _modifier.modifyResponse<T>(newRequest, response);

      if (HttpStatus.unauthorized == newResponse.statusCode &&
          _modifier.authenticator != null &&
          requestNumber <= maxAuthRetries) {
        return _performRequest<T>(
          handler,
          authenticate: true,
          requestNumber: requestNumber + 1,
          headers: newRequest.headers,
        );
      } else if (HttpStatus.unauthorized == newResponse.statusCode) {
        if (!errorSafety) {
          throw UnauthorizedException();
        } else {
          return Response<T>(
            request: newRequest,
            headers: newResponse.headers,
            statusCode: newResponse.statusCode,
            body: newResponse.body,
            bodyBytes: newResponse.bodyBytes,
            bodyString: newResponse.bodyString,
            statusText: newResponse.statusText,
          );
        }
      }

      return newResponse;
    } on Exception catch (err) {
      if (!errorSafety) {
        throw GetHttpException(err.toString());
      } else {
        return Response<T>(
          request: newRequest,
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
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
  ) {
    final headers = <String, String>{};
    _setSimpleHeaders(headers, contentType);
    final uri = createUri(url, query);

    return Future.value(Request<T>(
      method: 'get',
      url: uri,
      headers: headers,
      decoder: decoder ?? (defaultDecoder as Decoder<T>?),
      responseInterceptor: _responseInterceptor(responseInterceptor),
      contentLength: 0,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
    ));
  }

  ResponseInterceptor<T>? _responseInterceptor<T>(
      ResponseInterceptor<T>? actual) {
    if (actual != null) return actual;
    final defaultInterceptor = defaultResponseInterceptor;
    return defaultInterceptor != null
        ? (request, targetType, response) async =>
            await defaultInterceptor(request, targetType, response)
                as Response<T>?
        : null;
  }

  Future<Request<T>> _request<T>(
    String? url,
    String method, {
    String? contentType,
    required dynamic body,
    required Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    required Progress? uploadProgress,
  }) {
    return _requestWithBody<T>(
      url,
      contentType,
      body,
      method,
      query,
      decoder ?? (defaultDecoder as Decoder<T>?),
      _responseInterceptor(responseInterceptor),
      uploadProgress,
    );
  }

  Request<T> _delete<T>(
    String url,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
  ) {
    final headers = <String, String>{};
    _setSimpleHeaders(headers, contentType);
    final uri = createUri(url, query);

    return Request<T>(
      method: 'delete',
      url: uri,
      headers: headers,
      decoder: decoder ?? (defaultDecoder as Decoder<T>?),
      responseInterceptor: _responseInterceptor(responseInterceptor),
    );
  }

  Future<Response<T>> send<T>(Request<T> request) async {
    try {
      var response = await _performRequest<T>(() => Future.value(request));
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> patch<T>(
    String url, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
    // List<MultipartFile> files,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _request<T>(
          url,
          'patch',
          contentType: contentType,
          body: body,
          query: query,
          decoder: decoder,
          responseInterceptor: responseInterceptor,
          uploadProgress: uploadProgress,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> post<T>(
    String? url, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
    // List<MultipartFile> files,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _request<T>(
          url,
          'post',
          contentType: contentType,
          body: body,
          query: query,
          decoder: decoder,
          responseInterceptor: responseInterceptor,
          uploadProgress: uploadProgress,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> request<T>(
    String url,
    String method, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _request<T>(
          url,
          method,
          contentType: contentType,
          query: query,
          body: body,
          decoder: decoder,
          responseInterceptor: responseInterceptor,
          uploadProgress: uploadProgress,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> put<T>(
    String url, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _request<T>(
          url,
          'put',
          contentType: contentType,
          query: query,
          body: body,
          decoder: decoder,
          responseInterceptor: responseInterceptor,
          uploadProgress: uploadProgress,
        ),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
  }) async {
    try {
      var response = await _performRequest<T>(
        () => _get<T>(url, contentType, query, decoder, responseInterceptor),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  Future<Response<T>> delete<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      ResponseInterceptor<T>? responseInterceptor}) async {
    try {
      var response = await _performRequest<T>(
        () async =>
            _delete<T>(url, contentType, query, decoder, responseInterceptor),
        headers: headers,
      );
      return response;
    } on Exception catch (e) {
      if (!errorSafety) {
        throw GetHttpException(e.toString());
      }
      return Future.value(Response<T>(
        statusText: 'Can not connect to server. Reason: $e',
      ));
    }
  }

  void close() {
    _httpClient.close();
  }
}
