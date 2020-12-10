import 'dart:convert';

import '../../../../get_core/get_core.dart';

import '../request/request.dart';

T bodyDecoded<T>(Request<T> request, String stringBody) {
  T body;
  var bodyToDecode;
  try {
    bodyToDecode = jsonDecode(stringBody);
  } on FormatException catch (_) {
    Get.log('Cannot decode body in json');
    bodyToDecode = stringBody;
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
