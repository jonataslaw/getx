import '../../certificates/certificates.dart';
import '../stub/http_request_stub.dart'
    if (dart.library.js_interop) '../html/http_request_html.dart'
    if (dart.library.io) '../io/http_request_io.dart';

HttpRequestImpl createHttp({
  bool allowAutoSignedCert = true,
  List<TrustedCertificate>? trustedCertificates,
  bool withCredentials = false,
  String Function(Uri url)? findProxy,
}) {
  return HttpRequestImpl(
    allowAutoSignedCert: allowAutoSignedCert,
    trustedCertificates: trustedCertificates,
    withCredentials: withCredentials,
    findProxy: findProxy,
  );
}
