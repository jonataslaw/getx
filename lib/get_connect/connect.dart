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

abstract class GetConnectInterface with GetLifeCycleMixin {
  List<GetSocket>? sockets;
  GetHttpClient get httpClient;

  Future<Response<T>> get<T>(
    final String url, {
    final Map<String, String>? headers,
    final String? contentType,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
  });

  Future<Response<T>> request<T>(
    final String url,
    final String method, {
    final dynamic body,
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
  });

  Future<Response<T>> post<T>(
    final String url,
    final dynamic body, {
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
  });

  Future<Response<T>> put<T>(
    final String url,
    final dynamic body, {
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
  });

  Future<Response<T>> delete<T>(
    final String url, {
    final Map<String, String>? headers,
    final String? contentType,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
  });

  Future<Response<T>> patch<T>(
    final String url,
    final dynamic body, {
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
    final Progress? uploadProgress,
  });

  Future<GraphQLResponse<T>> query<T>(
    final String query, {
    final String? url,
    final Map<String, dynamic>? variables,
    final Map<String, String>? headers,
  });

  Future<GraphQLResponse<T>> mutation<T>(
    final String mutation, {
    final String? url,
    final Map<String, dynamic>? variables,
    final Map<String, String>? headers,
  });

  GetSocket socket(
    final String url, {
    final Duration ping = const Duration(seconds: 5),
  });
}

class GetConnect extends GetConnectInterface {
  GetConnect({
    this.userAgent = 'getx-client',
    this.timeout = const Duration(seconds: 5),
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.sendUserAgent = false,
    this.maxAuthRetries = 1,
    this.allowAutoSignedCert = false,
    this.withCredentials = false,
  });

  bool allowAutoSignedCert;
  String userAgent;
  bool sendUserAgent;
  String? baseUrl;
  String defaultContentType = 'application/json; charset=utf-8';
  bool followRedirects;
  int maxRedirects;
  int maxAuthRetries;
  Decoder? defaultDecoder;
  Duration timeout;
  List<TrustedCertificate>? trustedCertificates;
  String Function(Uri url)? findProxy;
  GetHttpClient? _httpClient;
  List<GetSocket>? _sockets;
  bool withCredentials;

  @override
  List<GetSocket> get sockets => _sockets ??= <GetSocket>[];

  @override
  GetHttpClient get httpClient => _httpClient ??= GetHttpClient(
      userAgent: userAgent,
      sendUserAgent: sendUserAgent,
      timeout: timeout,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      maxAuthRetries: maxAuthRetries,
      allowAutoSignedCert: allowAutoSignedCert,
      baseUrl: baseUrl,
      trustedCertificates: trustedCertificates,
      withCredentials: withCredentials,
      findProxy: findProxy,);

  @override
  Future<Response<T>> get<T>(
    final String url, {
    final Map<String, String>? headers,
    final String? contentType,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
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
    final String? url,
    final dynamic body, {
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
    final Progress? uploadProgress,
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
    final String url,
    final dynamic body, {
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
    final Progress? uploadProgress,
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
    final String url,
    final dynamic body, {
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
    final Progress? uploadProgress,
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
    final String url,
    final String method, {
    final dynamic body,
    final String? contentType,
    final Map<String, String>? headers,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
    final Progress? uploadProgress,
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
    final String url, {
    final Map<String, String>? headers,
    final String? contentType,
    final Map<String, dynamic>? query,
    final Decoder<T>? decoder,
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
    final String url, {
    final Duration ping = const Duration(seconds: 5),
  }) {
    _checkIfDisposed(isHttp: false);

    final newSocket = GetSocket(_concatUrl(url)!, ping: ping);
    sockets.add(newSocket);
    return newSocket;
  }

  String? _concatUrl(final String? url) {
    if (url == null) return baseUrl;
    return baseUrl == null ? url : baseUrl! + url;
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
    final String query, {
    final String? url,
    final Map<String, dynamic>? variables,
    final Map<String, String>? headers,
  }) async {
    try {
      final res = await post(
        url,
        {'query': query, 'variables': variables},
        headers: headers,
      );

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        return GraphQLResponse<T>(
            graphQLErrors: listError
                .map((final e) => GraphQLError(
                      code: e['extensions']['code']?.toString(),
                      message: e['message']?.toString(),
                    ),)
                .toList(),);
      }
      return GraphQLResponse<T>.fromResponse(res);
    } on Exception catch (_) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          message: _.toString(),
        ),
      ],);
    }
  }

  @override
  Future<GraphQLResponse<T>> mutation<T>(
    final String mutation, {
    final String? url,
    final Map<String, dynamic>? variables,
    final Map<String, String>? headers,
  }) async {
    try {
      final res = await post(
        url,
        {'query': mutation, 'variables': variables},
        headers: headers,
      );

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        return GraphQLResponse<T>(
            graphQLErrors: listError
                .map((final e) => GraphQLError(
                      code: e['extensions']['code']?.toString(),
                      message: e['message']?.toString(),
                    ),)
                .toList(),);
      }
      return GraphQLResponse<T>.fromResponse(res);
    } on Exception catch (_) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          message: _.toString(),
        ),
      ],);
    }
  }

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  void _checkIfDisposed({final bool isHttp = true}) {
    if (_isDisposed) {
      throw 'Can not emit events to disposed clients';
    }
  }

  void dispose() {
    if (_sockets != null) {
      for (final socket in sockets) {
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
