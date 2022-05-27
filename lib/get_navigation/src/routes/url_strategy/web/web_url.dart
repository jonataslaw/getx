import 'dart:html';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void removeHash() {
  setUrlStrategy(PathUrlStrategy());
}

void removeLastHistory(String? url) {
  window.location.replace(null);
}
