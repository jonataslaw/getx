import 'dart:async';
import 'dart:convert';

import '../../../../get_rx/src/rx_stream/rx_stream.dart';

import '../request/request.dart';

bool isTokenChar(int byte) {
  return byte > 31 && byte < 128 && !SEPARATOR_MAP[byte];
}

bool isValueChar(int byte) {
  return (byte > 31 && byte < 128) ||
      (byte == CharCode.SP) ||
      (byte == CharCode.HT);
}

class CharCode {
  static const int HT = 9;
  static const int LF = 10;
  static const int CR = 13;
  static const int SP = 32;
  static const int COMMA = 44;
  static const int SLASH = 47;
  static const int ZERO = 48;
  static const int ONE = 49;
  static const int COLON = 58;
  static const int SEMI_COLON = 59;
}

const bool F = false;

const String GET_BOUNDARY = '--get-boundary-';

const bool T = true;
const SEPARATOR_MAP = [
  F, F, F, F, F, F, F, F, F, T, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, T, F, T, F, F, F, F, F, T, T, F, F, T, F, F, T, //
  F, F, F, F, F, F, F, F, F, F, T, T, T, T, T, T, T, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, T, T, T, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, T, F, T, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F
];

String validateField(String field) {
  for (var i = 0; i < field.length; i++) {
    if (!isTokenChar(field.codeUnitAt(i))) {
      throw FormatException(
          'Invalid HTTP header field name: ${json.encode(field)}', field, i);
    }
  }
  return field.toLowerCase();
}

BodyBytes toBodyBytes(Stream<List<int>> stream) {
  if (stream is BodyBytes) return stream;
  return BodyBytes(stream);
}

final _asciiOnly = RegExp(r'^[\x00-\x7F]+$');

/// Returns whether [string] is composed entirely of ASCII-compatible
/// characters.
bool isPlainAscii(String string) => _asciiOnly.hasMatch(string);

String encodeMap(dynamic data, _Handler handler, {bool encode = true}) {
  return urlEncode(data, '', encode, handler).toString();
}

StringBuffer urlEncode(
  dynamic sub,
  String path,
  bool encode,
  _Handler handler,
) {
  var urlData = StringBuffer('');
  var first = true;
  var leftBracket = '[';
  var rightBracket = ']';

  if (encode) {
    leftBracket = '%5B';
    rightBracket = '%5D';
  }

  var encodeComponent = encode ? Uri.encodeQueryComponent : (e) => e;
  if (sub is List) {
    for (var i = 0; i < sub.length; i++) {
      urlEncode(
          sub[i],
          // ignore: lines_longer_than_80_chars
          '$path$leftBracket${(sub[i] is Map || sub[i] is List) ? i : ''}$rightBracket',
          encode,
          handler);
    }
  } else if (sub is Map) {
    sub.forEach((key, value) {
      if (path == '') {
        urlEncode(
          value,
          '${encodeComponent(key as String)}',
          encode,
          handler,
        );
      } else {
        urlEncode(
          value,
          '$path$leftBracket${encodeComponent(key as String)}$rightBracket',
          encode,
          handler,
        );
      }
    });
  } else {
    var str = handler(path, sub);
    var isNotEmpty = str != null && (str as String).trim().isNotEmpty;
    if (!first && isNotEmpty) {
      urlData.write('&');
    }
    first = false;
    if (isNotEmpty) {
      urlData.write(str);
    }
  }

  return urlData;
}

Future streamToFuture(Stream stream, GetStream sink) {
  var completer = Completer();
  stream.listen(sink.add,
      onError: sink.addError, onDone: () => completer.complete());
  return completer.future;
}

void stringToBytes(String string, GetStream stream) {
  stream.add(utf8.encode(string));
}

void writeLine(GetStream stream) => stream.add([13, 10]);

typedef _Handler = Function(String key, Object value);
