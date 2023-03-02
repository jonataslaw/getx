import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void removeHash() {
  setUrlStrategy(PathUrlStrategy());
}
