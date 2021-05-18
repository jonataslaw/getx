import 'dart:async';

import '../request/request.dart';
import '../response/response.dart';

typedef RequestModifier<T> = FutureOr<Request<T>> Function(Request<T?> request);

typedef ResponseModifier<T> = FutureOr Function(
    Request<T?> request, Response<T?> response);

typedef HandlerExecute<T> = Future<Request<T>> Function();

class GetModifier<T> {
  final _requestModifiers = <RequestModifier>[];
  final _responseModifiers = <ResponseModifier>[];
  RequestModifier? authenticator;

  void addRequestModifier<T>(RequestModifier<T> interceptor) {
    _requestModifiers.add(interceptor as RequestModifier);
  }

  void removeRequestModifier<T>(RequestModifier<T> interceptor) {
    _requestModifiers.remove(interceptor);
  }

  void addResponseModifier<T>(ResponseModifier<T> interceptor) {
    _responseModifiers.add(interceptor as ResponseModifier);
  }

  void removeResponseModifier<T>(ResponseModifier<T> interceptor) {
    _requestModifiers.remove(interceptor);
  }

  Future<Request<T>> modifyRequest<T>(Request<T> request) async {
    var newRequest = request;
    if (_requestModifiers.isNotEmpty) {
      for (var interceptor in _requestModifiers) {
        newRequest = await interceptor(newRequest) as Request<T>;
      }
    }

    return newRequest;
  }

  Future<Response<T>> modifyResponse<T>(
      Request<T> request, Response<T> response) async {
    var newResponse = response;
    if (_responseModifiers.isNotEmpty) {
      for (var interceptor in _responseModifiers) {
        newResponse = await interceptor(request, response) as Response<T>;
      }
    }

    return newResponse;
  }
}
