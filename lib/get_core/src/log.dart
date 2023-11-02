import 'dart:developer' as developer;
import 'get_main.dart';

///VoidCallback from logs
typedef LogWriterCallback = void Function(String text, {bool isError});

/// default logger from GetX
void defaultLogWriterCallback(final String value, {final bool isError = false}) {
  if (isError || Get.isLogEnable) developer.log(value, name: 'GETX');
}
