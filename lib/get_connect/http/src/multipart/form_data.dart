import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../../../get_rx/src/rx_stream/rx_stream.dart';
import '../request/request.dart';
import '../utils/utils.dart';
import 'multipart_file.dart';

class FormData {
  FormData(Map<String, dynamic> map) : boundary = _getBoundary() {
    urlEncode(map, '', false, (key, value) {
      if (value == null) return;
      (value is MultipartFile)
          ? files.add(MapEntry(key, value))
          : fields.add(MapEntry(key, value.toString()));
      return;
    });
  }

  static const int _maxBoundaryLength = 70;

  static String _getBoundary() {
    final _random = Random();
    var list = List<int>.generate(_maxBoundaryLength - GET_BOUNDARY.length,
        (_) => boundaryCharacters[_random.nextInt(boundaryCharacters.length)],
        growable: false);
    return '$GET_BOUNDARY${String.fromCharCodes(list)}';
  }

  final String boundary;

  /// The form fields to send for this request.
  final fields = <MapEntry<String, String>>[];

  /// The [files] to send for this request
  final files = <MapEntry<String, MultipartFile>>[];

  /// Returns the header string for a field. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fieldHeader(String name, String value) {
    var header =
        'content-disposition: form-data; name="${browserEncode(name)}"';
    if (!isPlainAscii(value)) {
      header = '$header\r\n'
          'content-type: text/plain; charset=utf-8\r\n'
          'content-transfer-encoding: binary';
    }
    return '$header\r\n\r\n';
  }

  /// Returns the header string for a file. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fileHeader(MapEntry<String, MultipartFile> file) {
    var header =
        'content-disposition: form-data; name="${browserEncode(file.key)}"';
    if (file.value.filename != null) {
      header = '$header; filename="${browserEncode(file.value.filename)}"';
    }
    header = '$header\r\n'
        'content-type: ${file.value.contentType}';
    return '$header\r\n\r\n';
  }

  /// The length of the request body from this [FormData]
  int get length {
    var length = 0;

    for (final item in fields) {
      length += '--'.length +
          _maxBoundaryLength +
          '\r\n'.length +
          utf8.encode(_fieldHeader(item.key, item.value)).length +
          utf8.encode(item.value).length +
          '\r\n'.length;
    }

    for (var file in files) {
      length += '--'.length +
          _maxBoundaryLength +
          '\r\n'.length +
          utf8.encode(_fileHeader(file)).length +
          file.value.length +
          '\r\n'.length;
    }

    return length + '--'.length + _maxBoundaryLength + '--\r\n'.length;
  }

  Future<List<int>> toBytes() {
    final getStream = GetStream<List<int>>();

    for (final item in fields) {
      stringToBytes('--$boundary\r\n', getStream);
      stringToBytes(_fieldHeader(item.key, item.value), getStream);
      stringToBytes(item.value, getStream);
      writeLine(getStream);
    }

    Future.forEach<MapEntry<String, MultipartFile>>(files, (file) {
      stringToBytes('--$boundary\r\n', getStream);
      stringToBytes(_fileHeader(file), getStream);

      return streamToFuture(file.value.stream, getStream)
          .then((_) => writeLine(getStream));
    }).then((_) {
      stringToBytes('--$boundary--\r\n', getStream);
      getStream.close();
    });
    return BodyBytes(getStream.stream).toBytes();
  }
}
