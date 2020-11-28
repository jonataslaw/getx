import 'src/sockets_stub.dart'
    if (dart.library.html) 'src/sockets_html.dart'
    if (dart.library.io) 'src/sockets_io.dart';

class GetSocket extends BaseWebSocket {
  GetSocket(
    String url, {
    Duration ping = const Duration(seconds: 5),
  }) : super(url, ping: ping);
}
