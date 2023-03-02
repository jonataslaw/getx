import '../../certificates/certificates.dart';
import '../../request/request.dart';
import '../../response/response.dart';
import '../interface/request_base.dart';

class HttpRequestImpl extends IClient {
  HttpRequestImpl({
    bool allowAutoSignedCert = true,
    List<TrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    String Function(Uri url)? findProxy,
  });
  @override
  void close() {}

  @override
  Future<Response<T>> send<T>(Request<T> request) {
    throw UnimplementedError();
  }
}
