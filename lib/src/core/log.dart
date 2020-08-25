import 'package:get/instance_manager.dart';

typedef LogWriterCallback = void Function(String text, {bool isError});

void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || GetConfig.isLogEnable) print(value);
}
