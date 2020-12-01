import '../get_instance/src/lifecycle.dart';
import 'http/src/certificates/certificates.dart';
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

  GetSocket socket(String url, {Duration ping = const Duration(seconds: 5)});
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
  }) {
    _checkIfDisposed();
    return httpClient.post<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
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
  }) {
    _checkIfDisposed();
    return httpClient.put<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
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
  GetSocket socket(String url, {Duration ping = const Duration(seconds: 5)}) {
    _checkIfDisposed(isHttp: false);
    final _url = baseUrl == null ? url : baseUrl + url;
    final _socket = GetSocket(_url, ping: ping);
    sockets.add(_socket);
    return _socket;
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
