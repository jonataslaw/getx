import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      home: Home(),
    ),
  );
}

class Controller extends GetxController {
  final count = 0.reactive;
  void increment() {
    count.value++;
    update();
  }
}

class Home extends ObxStatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    return Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleBuilder(builder: (context) {
              print('builder');
              return Text(
                '${controller.count.value}',
                style: TextStyle(fontSize: 30),
              );
            }),
            // ElevatedButton(
            //   child: Text('Next Route'),
            //   onPressed: () {
            //     Get.to(() => Second());
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: controller.increment,
      ),
    );
  }
}
