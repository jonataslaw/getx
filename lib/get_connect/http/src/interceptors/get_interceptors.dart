import '../request/request.dart';
import '../response/response.dart';

typedef RequestModifier = Future<Request> Function(Request request);

typedef ResponseModifier = Future<Null> Function(
    Request request, Response response);

typedef HandlerExecute<T> = Future<Request<T>> Function();

class GetModifier {
  final _requestModifiers = <RequestModifier>[];
  final _responseModifiers = <ResponseModifier>[];
  RequestModifier authenticator;

  void addRequestModifier(RequestModifier interceptor) {
    _requestModifiers.add(interceptor);
  }

  void removeRequestModifier(RequestModifier interceptor) {
    _requestModifiers.remove(interceptor);
  }

  void addResponseModifier(ResponseModifier interceptor) {
    _responseModifiers.add(interceptor);
  }

  void removeResponseModifier(ResponseModifier interceptor) {
    _requestModifiers.remove(interceptor);
  }

  Future<void> modifyRequest(Request request) async {
    if (_requestModifiers.isNotEmpty) {
      for (var interceptor in _requestModifiers) {
        await interceptor(request);
      }
    }
  }

  Future<void> modifyResponse(Request request, Response response) async {
    if (_responseModifiers.isNotEmpty) {
      for (var interceptor in _responseModifiers) {
        await interceptor(request, response);
      }
    }
  }
}
