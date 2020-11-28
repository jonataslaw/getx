class GetHttpException implements Exception {
  final String message;

  final Uri uri;

  GetHttpException(this.message, [this.uri]);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  @override
  String toString() {
    return 'Operation Unauthorized';
  }
}

class UnexpectedFormat implements Exception {
  final String message;
  UnexpectedFormat(this.message);
  @override
  String toString() {
    return 'Unexpected format: $message';
  }
}
