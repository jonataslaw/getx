import '../../certificates/certificates.dart';
import '../../request/request.dart';
import '../../response/response.dart';
import '../interface/request_base.dart';

class HttpRequestImpl extends IClient {
  HttpRequestImpl({
    final bool allowAutoSignedCert = true,
    final List<TrustedCertificate>? trustedCertificates,
    final bool withCredentials = false,
    final String Function(Uri url)? findProxy,
  });
  @override
  void close() {}

  @override
  Future<Response<T>> send<T>(final Request<T> request) {
    throw UnimplementedError();
  }
}
