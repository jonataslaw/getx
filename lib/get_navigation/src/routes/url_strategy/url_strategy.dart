import 'impl/stub_url.dart'
    if (dart.library.js_interop) 'impl/web_url.dart'
    if (dart.library.io) 'impl/io_url.dart';

void setUrlStrategy() {
  removeHash();
}

void removeLastHistory(String? url) {
  removeLastHistory(url);
}
