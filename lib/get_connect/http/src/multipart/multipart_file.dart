class MultipartFile {
  final String contentType;

  final Stream<List<int>> _stream;

  final int length;

  final String filename;

  MultipartFile(
    List<int> bytes, {
    this.filename,
    this.contentType = 'application/octet-stream',
  })  : length = bytes.length,
        _stream = Stream.fromIterable([bytes]);

  Stream<List<int>> get stream => _stream;
}
