import '../request/request.dart';

class MultipartFile {
  MultipartFile(
    List<int> bytes, {
    this.filename,
    this.contentType = 'application/octet-stream',
  })  : length = bytes.length,
        stream = BodyBytes.fromBytes(bytes);

  final String contentType;

  /// This stream will emit the file content of File.
  final BodyBytes stream;

  final int length;

  final String filename;
}
