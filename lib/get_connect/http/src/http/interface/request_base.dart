import '../../request/request.dart';
import '../../response/response.dart';

/// Abstract interface of [HttpRequestImpl].
abstract class HttpRequestBase {
  /// Sends an HTTP [Request].
  Future<Response<T>> send<T>(Request<T> request);

  /// Closes the [Request] and cleans up any resources associated with it.
  void close();
}
