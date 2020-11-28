import '../certificates/certificates.dart';
import '../request/request.dart';
import '../response/response.dart';
import 'request_base.dart';

class HttpRequestImpl extends HttpRequestBase {
  HttpRequestImpl({
    bool allowAutoSignedCert = true,
    List<TrustedCertificate> trustedCertificates,
  });
  @override
  void close() {}

  @override
  Future<Response<T>> send<T>(Request<T> request) {
    throw UnimplementedError();
  }
}
