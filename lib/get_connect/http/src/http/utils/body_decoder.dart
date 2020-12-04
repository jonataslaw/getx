import 'dart:convert';

import '../../../../../get_core/get_core.dart';

import '../../request/request.dart';

T bodyDecoded<T>(Request<T> request, String stringBody, String mimeType) {
  T body;
  var bodyToDecode;

  if (mimeType.contains('application/json')) {
    try {
      bodyToDecode = jsonDecode(stringBody);
    } on FormatException catch (_) {
      Get.log('Cannot decode server response to json');
      bodyToDecode = stringBody;
    }
  }

  try {
    if (request.decoder == null) {
      body = bodyToDecode as T;
    } else {
      body = request.decoder(bodyToDecode);
    }
  } on Exception catch (_) {
    body = stringBody as T;
  }

  return body;
}
