import 'package:get/instance_manager.dart';
import 'dart:developer' as developer;

typedef LogWriterCallback = void Function(String text, {String name, bool isError});

void defaultLogWriterCallback(String value, {String name, bool isError = false}) {
  if (isError || GetConfig.isLogEnable) developer.log(value, name: name);
}
