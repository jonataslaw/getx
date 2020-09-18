import 'dart:developer' as developer;
import 'get_main.dart';

typedef LogWriterCallback = void Function(String text, {bool isError});

void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Get.isLogEnable) developer.log(value, name: 'GETX');
}
