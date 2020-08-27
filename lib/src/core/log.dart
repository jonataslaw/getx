
import 'package:flutter/foundation.dart';
import 'package:get/instance_manager.dart';
import 'dart:developer' as developer;

typedef LogWriterCallback = void Function(String text, {@required String name, bool isError});

void defaultLogWriterCallback(String value, {@required String name, bool isError = false}) {
  if (isError || GetConfig.isLogEnable) developer.log(value, name: name);
}
