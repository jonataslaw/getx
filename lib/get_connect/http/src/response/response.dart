import 'dart:collection';
import 'dart:convert';

import '../exceptions/exceptions.dart';
import '../request/request.dart';
import '../status/http_status.dart';

class GraphQLResponse<T> extends Response<T> {

  GraphQLResponse({super.body, this.graphQLErrors});

  GraphQLResponse.fromResponse(final Response res)
      : graphQLErrors = null,
        super(
            request: res.request,
            statusCode: res.statusCode,
            bodyBytes: res.bodyBytes,
            bodyString: res.bodyString,
            statusText: res.statusText,
            headers: res.headers,
            body: res.body['data'] as T?);
  final List<GraphQLError>? graphQLErrors;
}

class Response<T> {
  const Response({
    this.request,
    this.statusCode,
    this.bodyBytes,
    this.bodyString,
    this.statusText = '',
    this.headers = const {},
    this.body,
  });

  Response<T> copyWith({
    final Request? request,
    final int? statusCode,
    final Stream<List<int>>? bodyBytes,
    final String? bodyString,
    final String? statusText,
    final Map<String, String>? headers,
    final T? body,
  }) {
    return Response<T>(
      request: request ?? this.request,
      statusCode: statusCode ?? this.statusCode,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      bodyString: bodyString ?? this.bodyString,
      statusText: statusText ?? this.statusText,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  /// The Http [Request] linked with this [Response].
  final Request? request;

  /// The response headers.
  final Map<String, String>? headers;

  /// The status code returned by the server.
  final int? statusCode;

  /// Human-readable context for [statusCode].
  final String? statusText;

  /// [HttpStatus] from [Response]. `status.connectionError` is true
  /// when statusCode is null. `status.isUnauthorized` is true when
  /// statusCode is equal `401`. `status.isNotFound` is true when
  /// statusCode is equal `404`. `status.isServerError` is true when
  /// statusCode is between `500` and `599`.
  HttpStatus get status => HttpStatus(statusCode);

  /// `hasError` is true when statusCode is not between 200 and 299.
  bool get hasError => status.hasError;

  /// `isOk` is true when statusCode is between 200 and 299.
  bool get isOk => !hasError;

  /// `unauthorized` is true when statusCode is equal `401`.
  bool get unauthorized => status.isUnauthorized;

  /// The response body as a Stream of Bytes.
  final Stream<List<int>>? bodyBytes;

  /// The response body as a Stream of Bytes.
  final String? bodyString;

  /// The decoded body of this [Response]. You can access the
  /// body parameters as Map
  /// Ex: `body['title'];`
  final T? body;
}

Future<String> bodyBytesToString(
    final Stream<List<int>> bodyBytes, final Map<String, String> headers) {
  return bodyBytes.bytesToString(_encodingForHeaders(headers));
}

/// Returns the encoding to use for a response with the given headers.
///
/// Defaults to [utf8] if the headers don't specify a charset or if that
/// charset is unknown.
Encoding _encodingForHeaders(final Map<String, String> headers) =>
    _encodingForCharset(_contentTypeForHeaders(headers).parameters!['charset']);

/// Returns the [Encoding] that corresponds to [charset].
///
/// Returns [fallback] if [charset] is null or if no [Encoding] was found that
/// corresponds to [charset].
Encoding _encodingForCharset(final String? charset, [final Encoding fallback = utf8]) {
  if (charset == null) return fallback;
  return Encoding.getByName(charset) ?? fallback;
}

/// Returns the MediaType object for the given headers's content-type.
///
/// Defaults to `application/octet-stream`.
HeaderValue _contentTypeForHeaders(final Map<String, String> headers) {
  final contentType = headers['content-type'];
  if (contentType != null) return HeaderValue.parse(contentType);
  return HeaderValue('application/octet-stream');
}

class HeaderValue {

  HeaderValue([this._value = '', final Map<String, String>? parameters]) {
    if (parameters != null) {
      _parameters = HashMap<String, String>.from(parameters);
    }
  }
  String _value;
  Map<String, String?>? _parameters;
  Map<String, String?>? _unmodifiableParameters;

  static HeaderValue parse(final String value,
      {final String parameterSeparator = ';',
      final String? valueSeparator,
      final bool preserveBackslash = false}) {
    final result = HeaderValue();
    result._parse(value, parameterSeparator, valueSeparator, preserveBackslash);
    return result;
  }

  String get value => _value;

  void _ensureParameters() {
    _parameters ??= HashMap<String, String>();
  }

  Map<String, String?>? get parameters {
    _ensureParameters();
    _unmodifiableParameters ??= UnmodifiableMapView(_parameters!);
    return _unmodifiableParameters;
  }

  @override
  String toString() {
    final stringBuffer = StringBuffer();
    stringBuffer.write(_value);
    if (parameters != null && parameters!.isNotEmpty) {
      _parameters!.forEach((final name, final value) {
        stringBuffer
          ..write('; ')
          ..write(name)
          ..write('=')
          ..write(value);
      });
    }
    return stringBuffer.toString();
  }

  void _parse(final String value, final String parameterSeparator, final String? valueSeparator,
      final bool preserveBackslash) {
    var index = 0;

    bool done() => index == value.length;

    void bump() {
      while (!done()) {
        if (value[index] != ' ' && value[index] != '\t') return;
        index++;
      }
    }

    String parseValue() {
      final start = index;
      while (!done()) {
        if (value[index] == ' ' ||
            value[index] == '\t' ||
            value[index] == valueSeparator ||
            value[index] == parameterSeparator) {
          break;
        }
        index++;
      }
      return value.substring(start, index);
    }

    void expect(final String expected) {
      if (done() || value[index] != expected) {
        throw StateError('Failed to parse header value');
      }
      index++;
    }

    void maybeExpect(final String expected) {
      if (value[index] == expected) index++;
    }

    void parseParameters() {
      final parameters = HashMap<String, String?>();
      _parameters = UnmodifiableMapView(parameters);

      String parseParameterName() {
        final start = index;
        while (!done()) {
          if (value[index] == ' ' ||
              value[index] == '\t' ||
              value[index] == '=' ||
              value[index] == parameterSeparator ||
              value[index] == valueSeparator) {
            break;
          }
          index++;
        }
        return value.substring(start, index).toLowerCase();
      }

      String? parseParameterValue() {
        if (!done() && value[index] == '"') {
          final stringBuffer = StringBuffer();
          index++;
          while (!done()) {
            if (value[index] == r'\') {
              if (index + 1 == value.length) {
                throw StateError('Failed to parse header value');
              }
              if (preserveBackslash && value[index + 1] != '"') {
                stringBuffer.write(value[index]);
              }
              index++;
            } else if (value[index] == '"') {
              index++;
              break;
            }
            stringBuffer.write(value[index]);
            index++;
          }
          return stringBuffer.toString();
        } else {
          final val = parseValue();
          return val == '' ? null : val;
        }
      }

      while (!done()) {
        bump();
        if (done()) return;
        final name = parseParameterName();
        bump();
        if (done()) {
          parameters[name] = null;
          return;
        }
        maybeExpect('=');
        bump();
        if (done()) {
          parameters[name] = null;
          return;
        }
        var valueParameter = parseParameterValue();
        if (name == 'charset' && valueParameter != null) {
          valueParameter = valueParameter.toLowerCase();
        }
        parameters[name] = valueParameter;
        bump();
        if (done()) return;
        if (value[index] == valueSeparator) return;
        expect(parameterSeparator);
      }
    }

    bump();
    _value = parseValue();
    bump();
    if (done()) return;
    maybeExpect(parameterSeparator);
    parseParameters();
  }
}
