import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  //MyBindings().dependencies();
  runApp(
    Binds(
      binds: [
        Bind.lazyPut(() => Controller()),
        Bind.lazyPut(() => Controller2()),
      ],
      child: GetMaterialApp(
        home: Home(),
      ),
    ),
  );
}



class MyBindings extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.put(Controller()),
      Bind.put(Controller2()),
    ];
  }
}

class Controller extends GetxController {
  final count = 0.obs;
  void increment() {
    count.value++;
    update();
  }
}

class Controller2 extends GetxController {
  final count = 0.obs;

  Controller2();
  void increment() {
    count.value++;
    update();
  }
}

class Home extends ObxStatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('sasasasa');
    return Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Builder(builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                print('builder');
                final controller = context.listen<Controller>();
                return Text('${controller.count.value}');
              }),
              ElevatedButton(
                child: Text('Next Route'),
                onPressed: () {
                  Get.to(() => Second());
                },
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.find<Controller>().increment();
        },
      ),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.get<Controller2>().increment();
        },
      ),
      body: Center(
        child: Builder(builder: (context) {
          final ctrl = context.listen<Controller2>();
          return Text("${ctrl.count}");
        }),
      ),
    );
  }
}
