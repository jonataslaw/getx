import '../get_instance/src/lifecycle.dart';
import 'http/src/certificates/certificates.dart';
import 'http/src/exceptions/exceptions.dart';
import 'http/src/http.dart';
import 'http/src/response/response.dart';
import 'sockets/sockets.dart';

export 'http/src/certificates/certificates.dart';
export 'http/src/http.dart';
export 'http/src/multipart/form_data.dart';
export 'http/src/multipart/multipart_file.dart';
export 'http/src/response/response.dart';
export 'sockets/sockets.dart';

abstract class GetConnectInterface with GetLifeCycleBase {
  List<GetSocket> sockets;
  GetHttpClient get httpClient;

  Future<Response<T>> get<T>(
    String url, {
    Map<String, String> headers,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  });

  Future<Response<T>> request<T>(
    String url,
    String method, {
    dynamic body,
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  });
  Future<Response<T>> post<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  });

  Future<Response<T>> put<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  });

  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String> headers,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  });

  Future<Response<T>> patch<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    Progress uploadProgress,
  });

  Future<GraphQLResponse<T>> query<T>(
    String query, {
    String url,
    Map<String, dynamic> variables,
    Map<String, String> headers,
  });

  Future<GraphQLResponse<T>> mutation<T>(
    String mutation, {
    String url,
    Map<String, dynamic> variables,
    Map<String, String> headers,
  });

  GetSocket socket(
    String url, {
    Duration ping = const Duration(seconds: 5),
  });
}

class GetConnect extends GetConnectInterface {
  GetConnect({
    this.userAgent = 'getx-client',
    this.timeout = const Duration(seconds: 5),
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.maxAuthRetries = 1,
    this.allowAutoSignedCert = false,
  }) {
    $configureLifeCycle();
  }

  bool allowAutoSignedCert;
  String userAgent;
  String baseUrl;
  String defaultContentType = 'application/json; charset=utf-8';
  bool followRedirects;
  int maxRedirects;
  int maxAuthRetries;
  Decoder defaultDecoder;
  Duration timeout;
  List<TrustedCertificate> trustedCertificates;
  GetHttpClient _httpClient;
  List<GetSocket> _sockets;

  @override
  List<GetSocket> get sockets => _sockets ??= <GetSocket>[];

  @override
  GetHttpClient get httpClient => _httpClient ??= GetHttpClient(
        userAgent: userAgent,
        timeout: timeout,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        maxAuthRetries: maxAuthRetries,
        allowAutoSignedCert: allowAutoSignedCert,
        baseUrl: baseUrl,
        trustedCertificates: trustedCertificates,
      );

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String> headers,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  }) {
    _checkIfDisposed();
    return httpClient.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    Progress uploadProgress,
  }) {
    _checkIfDisposed();
    return httpClient.post<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> put<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    Progress uploadProgress,
  }) {
    _checkIfDisposed();
    return httpClient.put<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> patch<T>(
    String url,
    dynamic body, {
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    Progress uploadProgress,
  }) {
    _checkIfDisposed();
    return httpClient.patch<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> request<T>(
    String url,
    String method, {
    dynamic body,
    String contentType,
    Map<String, String> headers,
    Map<String, dynamic> query,
    Decoder<T> decoder,
    Progress uploadProgress,
  }) {
    _checkIfDisposed();
    return httpClient.request<T>(
      url,
      method,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String> headers,
    String contentType,
    Map<String, dynamic> query,
    Decoder<T> decoder,
  }) {
    _checkIfDisposed();
    return httpClient.delete(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }

  @override
  GetSocket socket(
    String url, {
    Duration ping = const Duration(seconds: 5),
  }) {
    _checkIfDisposed(isHttp: false);

    final _socket = GetSocket(_concatUrl(url), ping: ping);
    sockets.add(_socket);
    return _socket;
  }

  String _concatUrl(String url) {
    if (url == null) return baseUrl;
    return baseUrl == null ? url : baseUrl + url;
  }

  /// query allow made GraphQL raw querys
  /// final connect = GetConnect();
  /// connect.baseUrl = 'https://countries.trevorblades.com/';
  /// final response = await connect.query(
  /// r"""
  /// {
  ///  country(code: "BR") {
  ///    name
  ///    native
  ///    currency
  ///    languages {
  ///      code
  ///      name
  ///    }
  ///  }
  ///}
  ///""",
  ///);
  ///print(response.body);
  @override
  Future<GraphQLResponse<T>> query<T>(
    String query, {
    String url,
    Map<String, dynamic> variables,
    Map<String, String> headers,
  }) async {
    try {
      final res = await post(
        _concatUrl(url),
        {'query': query, 'variables': variables},
        headers: headers,
      );

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        // return GraphQLResponse<T>(body: res.body['data'] as T);
        return GraphQLResponse<T>(
            graphQLErrors: listError
                .map((e) => GraphQLError(
                      code: e['extensions']['code']?.toString(),
                      message: e['message']?.toString(),
                    ))
                .toList());
      }
      return GraphQLResponse<T>(body: res.body['data'] as T);
    } on Exception catch (_) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          code: null,
          message: _.toString(),
        )
      ]);
    }
  }

  @override
  Future<GraphQLResponse<T>> mutation<T>(
    String mutation, {
    String url,
    Map<String, dynamic> variables,
    Map<String, String> headers,
  }) async {
    try {
      final res = await post(
        _concatUrl(url),
        {'query': mutation, 'variables': variables},
        headers: headers,
      );

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        // return GraphQLResponse<T>(body: res.body['data'] as T);
        return GraphQLResponse<T>(
            graphQLErrors: listError
                .map((e) => GraphQLError(
                      code: e['extensions']['code']?.toString(),
                      message: e['message']?.toString(),
                    ))
                .toList());
      }
      return GraphQLResponse<T>(body: res.body['data'] as T);
    } on Exception catch (_) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          code: null,
          message: _.toString(),
        )
      ]);
    }
  }

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  void _checkIfDisposed({bool isHttp = true}) {
    if (_isDisposed) {
      throw 'Can not emit events to disposed clients';
    }
  }

  void dispose() {
    if (_sockets != null) {
      for (var socket in sockets) {
        socket.close();
      }
      _sockets?.clear();
      sockets = null;
    }
    if (_httpClient != null) {
      httpClient.close();
      _httpClient = null;
    }
    _isDisposed = true;
  }
}
