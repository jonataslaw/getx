class GetHttpException implements Exception {

  GetHttpException(this.message, [this.uri]);
  final String message;

  final Uri? uri;

  @override
  String toString() => message;
}

class GraphQLError {
  GraphQLError({this.code, this.message});
  final String? message;
  final String? code;

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
  UnexpectedFormat(this.message);
  final String message;
  @override
  String toString() {
    return 'Unexpected format: $message';
  }
}
