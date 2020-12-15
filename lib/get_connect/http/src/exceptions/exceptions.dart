class GetHttpException implements Exception {
  final String message;

  final Uri uri;

  GetHttpException(this.message, [this.uri]);

  @override
  String toString() => message;
}

class GraphQLError {
  GraphQLError({this.code, this.message});
  final String message;
  final String code;

  @override
  String toString() => 'GETCONNECT ERROR:\n\tcode:$code\n\tmessage:$message';
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
