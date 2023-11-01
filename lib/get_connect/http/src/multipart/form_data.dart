import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../request/request.dart';
import '../utils/utils.dart';
import 'multipart_file.dart';

class FormData {
  FormData(final Map<String, dynamic> map) : boundary = _getBoundary() {
    map.forEach((final String key, final value) {
      if (value == null) {
        return;
      }
      if (value is MultipartFile) {
        files.add(MapEntry(key, value));
      } else if (value is List<MultipartFile>) {
        files.addAll(value.map((final MultipartFile e) => MapEntry(key, e)));
      } else if (value is List) {
        fields.addAll(value.map((final e) => MapEntry(key, e.toString())));
      } else {
        fields.add(MapEntry(key, value.toString()));
      }
    });
  }

  static const int _maxBoundaryLength = 70;

  static String _getBoundary() {
    final Random newRandom = Random();
    final List<int> list = List<int>.generate(
      _maxBoundaryLength - GET_BOUNDARY.length,
      (final _) =>
          boundaryCharacters[newRandom.nextInt(boundaryCharacters.length)],
      growable: false,
    );
    return '$GET_BOUNDARY${String.fromCharCodes(list)}';
  }

  final String boundary;

  /// The form fields to send for this request.
  final List<MapEntry<String, String>> fields = <MapEntry<String, String>>[];

  /// The files to send for this request
  final List<MapEntry<String, MultipartFile>> files =
      <MapEntry<String, MultipartFile>>[];

  /// Returns the header string for a field. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fieldHeader(final String name, final String value) {
    String header =
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
  String _fileHeader(final MapEntry<String, MultipartFile> file) {
    String header =
        'content-disposition: form-data; name="${browserEncode(file.key)}"';
    header = '$header; filename="${browserEncode(file.value.filename)}"';
    header = '$header\r\n'
        'content-type: ${file.value.contentType}';
    return '$header\r\n\r\n';
  }

  /// The length of the request body from this [FormData]
  int get length {
    int length = 0;

    for (final MapEntry<String, String> item in fields) {
      length += '--'.length +
          _maxBoundaryLength +
          '\r\n'.length +
          utf8.encode(_fieldHeader(item.key, item.value)).length +
          utf8.encode(item.value).length +
          '\r\n'.length;
    }

    for (final MapEntry<String, MultipartFile> file in files) {
      length += '--'.length +
          _maxBoundaryLength +
          '\r\n'.length +
          utf8.encode(_fileHeader(file)).length +
          file.value.length! +
          '\r\n'.length;
    }

    return length + '--'.length + _maxBoundaryLength + '--\r\n'.length;
  }

  Future<List<int>> toBytes() {
    return BodyBytesStream(_encode()).toBytes();
  }

  Stream<List<int>> _encode() async* {
    const List<int> line = <int>[13, 10];
    final List<int> separator = utf8.encode('--$boundary\r\n');
    final List<int> close = utf8.encode('--$boundary--\r\n');

    for (final MapEntry<String, String> field in fields) {
      yield separator;
      yield utf8.encode(_fieldHeader(field.key, field.value));
      yield utf8.encode(field.value);
      yield line;
    }

    for (final MapEntry<String, MultipartFile> file in files) {
      yield separator;
      yield utf8.encode(_fileHeader(file));
      yield* file.value.stream!;
      yield line;
    }
    yield close;
  }
}
