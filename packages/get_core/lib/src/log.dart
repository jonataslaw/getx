import 'dart:developer' as developer;
import 'get_main.dart';

///Voidcallback from logs
typedef LogWriterCallback = void Function(String text, {bool isError});

/// default logger from GetX
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Get.isLogEnable) developer.log(value, name: 'GETX');
}
