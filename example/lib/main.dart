import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'lang/translation_service.dart';
// import 'routes/app_pages.dart';
// import 'shared/logger/logger_utils.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       debugShowCheckedModeBanner: false,
//       enableLog: true,
//       logWriterCallback: Logger.write,
//       initialRoute: AppPages.INITIAL,
//       getPages: AppPages.routes,
//       locale: TranslationService.locale,
//       fallbackLocale: TranslationService.fallbackLocale,
//       translations: TranslationService(),
//     );
//   }
// }

/// Nav 2 snippet
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
            participatesInRootNavigator: true,
            name: '/first',
            page: () => const First()),
        GetPage(
          name: '/second',
          page: () => const Second(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: '/third',
          page: () => const Third(),
        ),
        GetPage(
          name: '/fourth',
          page: () => const Fourth(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirstController extends GetxController {
  @override
  void onClose() {
    print('on close first');
    super.onClose();
  }
}

class First extends StatelessWidget {
  const First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('First rebuild');
    Get.put(FirstController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('page one'),
        leading: IconButton(
          icon: const Icon(Icons.more),
          onPressed: () {
            Get.snackbar(
              'title',
              "message",
              mainButton:
                  TextButton(onPressed: () {}, child: const Text('button')),
              isDismissible: true,
              duration: Duration(seconds: 5),
              snackbarStatus: (status) => print(status),
            );
            // print('THEME CHANGED');
            // Get.changeTheme(
            //     Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed('/second?id=123');
            },
            child: const Text('next screen'),
          ),
        ),
      ),
    );
  }
}

class SecondController extends GetxController {
  final textEdit = TextEditingController();
  @override
  void onClose() {
    print('on close second');
    textEdit.dispose();
    super.onClose();
  }
}

class Second extends StatelessWidget {
  const Second({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SecondController());
    print('second rebuild');
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => print('pop invoked'),
      child: Scaffold(
        appBar: AppBar(
          title: Text('page two ${Get.parameters["id"]}'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: TextField(
                controller: controller.textEdit,
              )),
              SizedBox(
                height: 300,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/third');
                  },
                  child: const Text('next screen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Third extends StatelessWidget {
  const Third({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('page three'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: ElevatedButton(
            onPressed: () {
              Get.offNamedUntil('/fourth', (route) {
                return Get.currentRoute == '/first';
              });
            },
            child: const Text('go to first screen'),
          ),
        ),
      ),
    );
  }
}

class Fourth extends StatelessWidget {
  const Fourth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('page four'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('go to first screen'),
          ),
        ),
      ),
    );
  }
}
