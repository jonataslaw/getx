
import 'package:get/instance_manager.dart';
import 'dart:developer' as developer;

typedef LogWriterCallback = void Function(String text, {bool isError});

void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || GetConfig.isLogEnable) developer.log(value, name: 'GETX');
}
