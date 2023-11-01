import '../../certificates/certificates.dart';
import '../stub/http_request_stub.dart'
    if (dart.library.html) '../html/http_request_html.dart'
    if (dart.library.io) '../io/http_request_io.dart';

HttpRequestImpl createHttp({
  final bool allowAutoSignedCert = true,
  final List<TrustedCertificate>? trustedCertificates,
  final bool withCredentials = false,
  final String Function(Uri url)? findProxy,
}) {
  return HttpRequestImpl(
    allowAutoSignedCert: allowAutoSignedCert,
    trustedCertificates: trustedCertificates,
    withCredentials: withCredentials,
    findProxy: findProxy,
  );
}
