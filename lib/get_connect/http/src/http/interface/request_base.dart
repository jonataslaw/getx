import '../../request/request.dart';
import '../../response/response.dart';

/// Abstract interface of [HttpRequestImpl].
abstract class HttpRequestBase {
  /// Sends an HTTP [Request].
  Future<Response<T>> send<T>(Request<T> request);

  /// Closes the [Request] and cleans up any resources associated with it.
  void close();

  /// Gets and sets the timeout.
  ///
  /// For mobile, this value will be applied for both connection and request
  /// timeout.
  ///
  /// For web, this value will be the request timeout.
  Duration? timeout;
}
