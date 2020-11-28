import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../../../get_rx/src/rx_stream/rx_stream.dart';

import '../utils/utils.dart';

import 'multipart_file.dart';

class FormData {
  static const _BOUNDARY_LENGTH = GET_BOUNDARY.length + 10;

  final String boundary;

  /// The boundary of FormData, it consists of a constant prefix and a random
  /// postfix to assure the the boundary unpredictable and unique, each FormData
  /// instance will be different.

  final _newlineRegExp = RegExp(r'\r\n|\r|\n');

  /// The form fields to send for this request.
  final fields = <MapEntry<String, String>>[];

  /// The [files].
  final files = <MapEntry<String, MultipartFile>>[];

  /// Whether [finalize] has been called.
  bool get isFinalized => _isFinalized;
  bool _isFinalized = false;

  FormData(Map<String, dynamic> map)
      : boundary = GET_BOUNDARY +
            Random().nextInt(4294967296).toString().padLeft(10, '0') {
    encodeMap(
      map,
      (key, value) {
        if (value == null) return null;
        if (value is MultipartFile) {
          files.add(MapEntry(key, value));
        } else {
          fields.add(MapEntry(key, value.toString()));
        }
        return null;
      },
      encode: false,
    );
  }

  /// Returns the header string for a field. The return value is guaranteed to
  /// contain only ASCII characters.
  String _headerForField(String name, String value) {
    var header =
        'content-disposition: form-data; name="${_browserEncode(name)}"';
    if (!isPlainAscii(value)) {
      header = '$header\r\n'
          'content-type: text/plain; charset=utf-8\r\n'
          'content-transfer-encoding: binary';
    }
    return '$header\r\n\r\n';
  }

  /// Returns the header string for a file. The return value is guaranteed to
  /// contain only ASCII characters.
  String _headerForFile(MapEntry<String, MultipartFile> entry) {
    var file = entry.value;
    var header =
        'content-disposition: form-data; name="${_browserEncode(entry.key)}"';
    if (file.filename != null) {
      header = '$header; filename="${_browserEncode(file.filename)}"';
    }
    header = '$header\r\n'
        'content-type: ${file.contentType}';
    return '$header\r\n\r\n';
  }

  /// Encode [value] in the same way browsers do.
  String _browserEncode(String value) {
    // http://tools.ietf.org/html/rfc2388 mandates some complex encodings for
    // field names and file names, but in practice user agents seem not to
    // follow this at all. Instead, they URL-encode `\r`, `\n`, and `\r\n` as
    // `\r\n`; URL-encode `"`; and do nothing else (even for `%` or non-ASCII
    // characters). We follow their behavior.
    return value.replaceAll(_newlineRegExp, '%0D%0A').replaceAll('"', '%22');
  }

  /// The total length of the request body, in bytes. This is calculated from
  /// [fields] and [files] and cannot be set manually.
  int get length {
    var length = 0;

    for (final item in fields) {
      length += '--'.length +
          _BOUNDARY_LENGTH +
          '\r\n'.length +
          utf8.encode(_headerForField(item.key, item.value)).length +
          utf8.encode(item.value).length +
          '\r\n'.length;
    }

    for (var file in files) {
      length += '--'.length +
          _BOUNDARY_LENGTH +
          '\r\n'.length +
          utf8.encode(_headerForFile(file)).length +
          file.value.length +
          '\r\n'.length;
    }

    return length + '--'.length + _BOUNDARY_LENGTH + '--\r\n'.length;
  }

  Stream<List<int>> finalize() {
    if (isFinalized) {
      throw StateError("Can't finalize a finalized MultipartFile.");
    }
    _isFinalized = true;
    final getStream = GetStream<List<int>>();

    for (final item in fields) {
      stringToBytes('--$boundary\r\n', getStream);
      stringToBytes(_headerForField(item.key, item.value), getStream);
      stringToBytes(item.value, getStream);
      writeLine(getStream);
    }

    Future.forEach<MapEntry<String, MultipartFile>>(files, (file) {
      stringToBytes('--$boundary\r\n', getStream);
      stringToBytes(_headerForFile(file), getStream);

      return streamToFuture(file.value.stream, getStream)
          .then((_) => writeLine(getStream));
    }).then((_) {
      stringToBytes('--$boundary--\r\n', getStream);
      getStream.close();
    });
    return getStream.stream;
  }

  ///Transform the entire FormData contents as a list of bytes asynchronously.
  Future<List<int>> readAsBytes() {
    return Future(() => finalize().reduce((a, b) => [...a, ...b]));
  }
}
