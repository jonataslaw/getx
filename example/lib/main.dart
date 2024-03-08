import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scaffold demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: Text('Tap me when Snackbar appears'),
          onPressed: () {
            print('This should clicked');
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.snackbar(
              "Snackbar Showed",
              "Please click the button on BottomNavigationBar",
              icon: Icon(Icons.check, color: Colors.green),
              backgroundColor: Colors.white,
              snackStyle: SnackStyle.floating,
              borderRadius: 20,
              isDismissible: false,
              snackPosition: SnackPosition.bottom,
              margin: EdgeInsets.fromLTRB(50, 15, 50, 15),
            );
          },
        ),
      ),
    );
  }
}
