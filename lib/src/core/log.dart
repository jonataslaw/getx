import 'dart:developer' as developer;

import '../../instance_manager.dart';

typedef LogWriterCallback = void Function(String text, {bool isError});

void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || GetConfig.isLogEnable) developer.log(value, name: 'GETX');
}
