import 'dart:async';
import 'dart:io' as io;

import '../../certificates/certificates.dart';
import '../../exceptions/exceptions.dart';
import '../../request/request.dart';
import '../../response/client_response.dart';
import '../../response/response.dart';
import '../interface/request_base.dart';
import '../utils/body_decoder.dart';

class IoRedirectInfo implements RedirectInfo {
  final io.RedirectInfo _redirectInfo;
  IoRedirectInfo({required io.RedirectInfo redirectInfo})
      : _redirectInfo = redirectInfo;

  @override
  int get statusCode => _redirectInfo.statusCode;

  @override
  String get method => _redirectInfo.method;

  @override
  Uri get location => _redirectInfo.location;
}

class IoHttpHeaders implements HttpHeaders {
  final io.HttpHeaders _headers;
  IoHttpHeaders({required io.HttpHeaders headers}) : _headers = headers;

  @override
  bool get chunkedTransferEncoding => _headers.chunkedTransferEncoding;

  @override
  int get contentLength => _headers.contentLength;

  @override
  DateTime? get date => _headers.date;

  @override
  DateTime? get expires => _headers.expires;

  @override
  String? get host => _headers.host;

  @override
  DateTime? get ifModifiedSince => _headers.ifModifiedSince;

  @override
  bool get persistentConnection => _headers.persistentConnection;

  @override
  int? get port => _headers.port;

  @override
  List<String>? operator [](String name) {
    return _headers[name];
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.add(name, value, preserveHeaderCase: preserveHeaderCase);
  }

  @override
  void clear() {
    _headers.clear();
  }

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _headers.forEach(action);
  }

  @override
  void noFolding(String name) {
    _headers.noFolding(name);
  }

  @override
  void remove(String name, Object value) {
    _headers.remove(name, value);
  }

  @override
  void removeAll(String name) {
    _headers.removeAll(name);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.set(name, value, preserveHeaderCase: preserveHeaderCase);
  }

  @override
  String? value(String name) {
    return _headers.value(name);
  }

  @override
  set chunkedTransferEncoding(bool chunkedTransferEncoding) {
    _headers.chunkedTransferEncoding = chunkedTransferEncoding;
  }

  @override
  set contentLength(int contentLength) {
    _headers.contentLength = contentLength;
  }

  @override
  set date(DateTime? date) {
    _headers.date = date;
  }

  @override
  set expires(DateTime? expires) {
    _headers.expires = expires;
  }

  @override
  set host(String? host) {
    _headers.host = host;
  }

  @override
  set ifModifiedSince(DateTime? ifModifiedSince) {
    _headers.ifModifiedSince = ifModifiedSince;
  }

  @override
  set persistentConnection(bool persistentConnection) {
    _headers.persistentConnection = persistentConnection;
  }

  @override
  set port(int? port) {
    _headers.port = port;
  }
}

class IOHttpResponse implements HttpClientResponse {
  IOHttpResponse({required io.HttpClientResponse response})
      : _response = response;
  final io.HttpClientResponse _response;
  @override
  Future<bool> any(bool Function(List<int> element) test) {
    return _response.any(test);
  }

  @override
  Stream<List<int>> asBroadcastStream(
      {void Function(StreamSubscription<List<int>> subscription)? onListen,
      void Function(StreamSubscription<List<int>> subscription)? onCancel}) {
    return _response.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) {
    return _response.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) {
    return _response.asyncMap(convert);
  }

  @override
  Stream<R> cast<R>() {
    return _response.cast<R>();
  }

  @override
  Future<bool> contains(Object? needle) {
    return _response.contains(needle);
  }

  @override
  int get contentLength => _response.contentLength;

  @override
  Stream<List<int>> distinct(
      [bool Function(List<int> previous, List<int> next)? equals]) {
    return _response.distinct(equals);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return _response.drain(futureValue);
  }

  @override
  Future<List<int>> elementAt(int index) {
    return _response.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(List<int> element) test) {
    return _response.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) {
    return _response.expand(convert);
  }

  @override
  Future<List<int>> get first => _response.first;

  @override
  Future<List<int>> firstWhere(bool Function(List<int> element) test,
      {List<int> Function()? orElse}) {
    return _response.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(
      S initialValue, S Function(S previous, List<int> element) combine) {
    return _response.fold(initialValue, combine);
  }

  @override
  Future<void> forEach(void Function(List<int> element) action) {
    return _response.forEach(action);
  }

  @override
  Stream<List<int>> handleError(Function onError,
      {bool Function(dynamic error)? test}) {
    return _response.handleError(onError, test: test);
  }

  @override
  HttpHeaders get headers => IoHttpHeaders(headers: _response.headers);

  @override
  bool get isBroadcast => _response.isBroadcast;

  @override
  Future<bool> get isEmpty => _response.isEmpty;

  @override
  bool get isRedirect => _response.isRedirect;

  @override
  Future<String> join([String separator = ""]) {
    return _response.join(separator);
  }

  @override
  Future<List<int>> get last => _response.last;

  @override
  Future<List<int>> lastWhere(bool Function(List<int> element) test,
      {List<int> Function()? orElse}) {
    return _response.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => _response.length;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _response.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) {
    return _response.map(convert);
  }

  @override
  bool get persistentConnection => _response.persistentConnection;

  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) {
    return _response.pipe(streamConsumer);
  }

  @override
  String get reasonPhrase => _response.reasonPhrase;

  @override
  Future<HttpClientResponse> redirect(
      [String? method, Uri? url, bool? followLoops]) async {
    final data = await _response.redirect(method, url, followLoops);
    return IOHttpResponse(response: data);
  }

  @override
  List<RedirectInfo> get redirects => _response.redirects
      .map((item) => IoRedirectInfo(redirectInfo: item))
      .toList();

  @override
  Future<List<int>> reduce(
      List<int> Function(List<int> previous, List<int> element) combine) {
    return _response.reduce(combine);
  }

  @override
  Future<List<int>> get single => _response.single;

  @override
  Future<List<int>> singleWhere(bool Function(List<int> element) test,
      {List<int> Function()? orElse}) {
    return _response.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<List<int>> skip(int count) {
    return _response.skip(count);
  }

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) {
    return _response.skipWhile(test);
  }

  @override
  int get statusCode => _response.statusCode;

  @override
  Stream<List<int>> take(int count) {
    return _response.take(count);
  }

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) {
    return _response.takeWhile(test);
  }

  @override
  Stream<List<int>> timeout(Duration timeLimit,
      {void Function(EventSink<List<int>> sink)? onTimeout}) {
    return _response.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<List<int>>> toList() {
    return _response.toList();
  }

  @override
  Future<Set<List<int>>> toSet() {
    return _response.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return _response.transform(streamTransformer);
  }

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) {
    return _response.where(test);
  }
}

/// A `dart:io` implementation of `IClient`.
class HttpRequestImpl extends IClient {
  io.HttpClient? _httpClient;
  io.SecurityContext? _securityContext;

  HttpRequestImpl({
    bool allowAutoSignedCert = true,
    List<TrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    String Function(Uri url)? findProxy,
  }) {
    _httpClient = io.HttpClient();
    if (trustedCertificates != null) {
      _securityContext = io.SecurityContext();
      for (final trustedCertificate in trustedCertificates) {
        _securityContext!
            .setTrustedCertificatesBytes(List.from(trustedCertificate.bytes));
      }
    }

    _httpClient = io.HttpClient(context: _securityContext);
    _httpClient!.badCertificateCallback = (_, __, ___) => allowAutoSignedCert;
    _httpClient!.findProxy = findProxy;
  }

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    var stream = request.bodyBytes.asBroadcastStream();
    io.HttpClientRequest? ioRequest;
    try {
      _httpClient!.connectionTimeout = timeout;
      ioRequest = (await _httpClient!.openUrl(request.method, request.url))
        ..followRedirects = request.followRedirects
        ..persistentConnection = request.persistentConnection
        ..maxRedirects = request.maxRedirects
        ..contentLength = request.contentLength ?? -1;
      request.headers.forEach(ioRequest.headers.set);

      var response = timeout == null
          ? await stream.pipe(ioRequest) as io.HttpClientResponse
          : await stream.pipe(ioRequest).timeout(timeout!)
              as io.HttpClientResponse;

      var headers = <String, String>{};
      response.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });

      final bodyBytes = (response);

      final interceptionResponse = await request.responseInterceptor
          ?.call(request, T, IOHttpResponse(response: response));
      if (interceptionResponse != null) return interceptionResponse;

      final stringBody = await bodyBytesToString(bodyBytes, headers);

      final body = bodyDecoded<T>(
        request,
        stringBody,
        response.headers.contentType?.mimeType,
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
    } on TimeoutException catch (_) {
      ioRequest?.abort();
      rethrow;
    } on io.HttpException catch (error) {
      throw GetHttpException(error.message, error.uri);
    }
  }

  /// Closes the HttpClient.
  @override
  void close() {
    if (_httpClient != null) {
      _httpClient!.close(force: true);
      _httpClient = null;
    }
  }
}

// extension FileExt on io.FileSystemEntity {
//   String get fileName {
//     return this?.path?.split(io.Platform.pathSeparator)?.last;
//   }
// }
