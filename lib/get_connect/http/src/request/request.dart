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
  }) {
    if (followRedirects) {
      assert(maxRedirects > 0);
    }
    return Request._(
      url: url,
      method: method,
      bodyBytes: bodyBytes ??= BodyBytesStream.fromBytes(const []),
      headers: Map.from(headers),
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      contentLength: contentLength,
      files: files,
      persistentConnection: persistentConnection,
      decoder: decoder,
    );
  }

  Request copyWith({
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
  }) {
    if (followRedirects) {
      assert(maxRedirects > 0);
    }
    return Request._(
      url: url,
      method: method,
      bodyBytes: bodyBytes ??= BodyBytesStream.fromBytes(const []),
      headers: Map.from(headers),
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      contentLength: contentLength,
      files: files,
      persistentConnection: persistentConnection,
      decoder: decoder,
    );
  }
}

extension BodyBytesStream on Stream<List<int>> {
  static Stream<List<int>> fromBytes(List<int> bytes) =>
      Stream.fromIterable([bytes]);

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
