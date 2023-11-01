import 'dart:async';

import '../request/request.dart';
import '../response/response.dart';

typedef RequestModifier<T> = FutureOr<Request<T>> Function(Request<T?> request);

typedef ResponseModifier<T> = FutureOr Function(
    Request<T?> request, Response<T?> response,);

typedef HandlerExecute<T> = Future<Request<T>> Function();

class GetModifier<S> {
  final _requestModifiers = <RequestModifier>[];
  final _responseModifiers = <ResponseModifier>[];
  RequestModifier? authenticator;

  void addRequestModifier<T>(final RequestModifier<T> interceptor) {
    _requestModifiers.add(interceptor as RequestModifier);
  }

  void removeRequestModifier<T>(final RequestModifier<T> interceptor) {
    _requestModifiers.remove(interceptor);
  }

  void addResponseModifier<T>(final ResponseModifier<T> interceptor) {
    _responseModifiers.add(interceptor as ResponseModifier);
  }

  void removeResponseModifier<T>(final ResponseModifier<T> interceptor) {
    _requestModifiers.remove(interceptor);
  }

  Future<Request<T>> modifyRequest<T>(final Request<T> request) async {
    var newRequest = request;
    if (_requestModifiers.isNotEmpty) {
      for (final interceptor in _requestModifiers) {
        newRequest = await interceptor(newRequest) as Request<T>;
      }
    }

    return newRequest;
  }

  Future<Response<T>> modifyResponse<T>(
      final Request<T> request, final Response<T> response,) async {
    var newResponse = response;
    if (_responseModifiers.isNotEmpty) {
      for (final interceptor in _responseModifiers) {
        newResponse = await interceptor(request, response) as Response<T>;
      }
    }

    return newResponse;
  }
}
