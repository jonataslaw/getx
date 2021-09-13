import 'dart:io';

class HttpStatusHelper {
  HttpStatusHelper(this.code);

  final int? code;

  bool get connectionError => code == null;

  bool get isUnauthorized => code == HttpStatus.unauthorized;

  bool get isForbidden => code == HttpStatus.forbidden;

  bool get isNotFound => code == HttpStatus.notFound;

  bool get isServerError => between(
        HttpStatus.internalServerError,
        HttpStatus.networkConnectTimeoutError,
      );

  bool between(int begin, int end) {
    return !connectionError && code! >= begin && code! <= end;
  }

  bool get isOk => between(200, 299);

  bool get hasError => !isOk;
}
