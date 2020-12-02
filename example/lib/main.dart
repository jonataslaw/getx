import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'shared/logger/logger_utils.dart';

void main() async {
  final client = GetConnect();
  final form = FormData({
    'file': MultipartFile(
      File('README.md').readAsBytesSync(),
      filename: 'readme.md',
    ),
  });
  final response = await client.post('http://localhost:8080/upload', form);

  print(response.body);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
