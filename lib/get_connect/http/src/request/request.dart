import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../http.dart';
import '../multipart/form_data.dart';

class Request<T> {
  /// Headers attach to this [Request]
  final Map<String, String> headers;

  /// The [Uri] from request
  final Uri url;

  final Decoder<T>? decoder;

  final ResponseInterceptor<T>? responseInterceptor;

  /// The Http Method from this [Request]
  /// ex: `GET`,`POST`,`PUT`,`DELETE`
  final String method;

  final int? contentLength;

  /// The BodyBytesStream of body from this [Request]
  final Stream<List<int>> bodyBytes;

  /// When true, the client will follow redirects to resolves this [Request]
  final bool followRedirects;

  /// The maximum number of redirects if [followRedirects] is true.
  final int maxRedirects;

  final bool persistentConnection;

  final FormData? files;

  const Request._({
    required this.method,
    required this.bodyBytes,
    required this.url,
    required this.headers,
    required this.contentLength,
    required this.followRedirects,
    required this.maxRedirects,
    required this.files,
    required this.persistentConnection,
    required this.decoder,
    this.responseInterceptor,
  });

  factory Request({
    required Uri url,
    required String method,
    required Map<String, String> headers,
    Stream<List<int>>? bodyBytes,
    bool followRedirects = true,
    int maxRedirects = 4,
    int? contentLength,
    FormData? files,
    bool persistentConnection = true,
    Decoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
  }) {
    if (followRedirects) {
      assert(maxRedirects > 0);
    }
    return Request._(
        url: url,
        method: method,
        bodyBytes: bodyBytes ??= <int>[].toStream(),
        headers: Map.from(headers),
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        contentLength: contentLength,
        files: files,
        persistentConnection: persistentConnection,
        decoder: decoder,
        responseInterceptor: responseInterceptor);
  }

  Request<T> copyWith({
    Uri? url,
    String? method,
    Map<String, String>? headers,
    Stream<List<int>>? bodyBytes,
    bool? followRedirects,
    int? maxRedirects,
    int? contentLength,
    FormData? files,
    bool? persistentConnection,
    Decoder<T>? decoder,
    bool appendHeader = true,
    ResponseInterceptor<T>? responseInterceptor,
  }) {
    // If appendHeader is set to true, we will merge origin headers with that
    if (appendHeader && headers != null) {
      headers.addAll(this.headers);
    }

    return Request<T>._(
        url: url ?? this.url,
        method: method ?? this.method,
        bodyBytes: bodyBytes ?? this.bodyBytes,
        headers: headers == null ? this.headers : Map.from(headers),
        followRedirects: followRedirects ?? this.followRedirects,
        maxRedirects: maxRedirects ?? this.maxRedirects,
        contentLength: contentLength ?? this.contentLength,
        files: files ?? this.files,
        persistentConnection: persistentConnection ?? this.persistentConnection,
        decoder: decoder ?? this.decoder,
        responseInterceptor: responseInterceptor ?? this.responseInterceptor);
  }
}

extension StreamExt on List<int> {
  Stream<List<int>> toStream() => Stream.value(this).asBroadcastStream();
}

extension BodyBytesStream on Stream<List<int>> {
  Future<Uint8List> toBytes() {
    var completer = Completer<Uint8List>();
    var sink = ByteConversionSink.withCallback(
      (bytes) => completer.complete(
        Uint8List.fromList(bytes),
      ),
    );
    listen((val) => sink.add(val),
        onError: completer.completeError,
        onDone: sink.close,
        cancelOnError: true);
    return completer.future;
  }

  Future<String> bytesToString([Encoding encoding = utf8]) =>
      encoding.decodeStream(this);
}
