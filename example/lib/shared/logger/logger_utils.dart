import 'package:flutter/widgets.dart';

mixin Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    Future.microtask(() => debugPrint('** $text. isError: [$isError]'));
  }
}
