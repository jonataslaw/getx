// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'lang/translation_service.dart';
// import 'routes/app_pages.dart';
// import 'shared/logger/logger_utils.dart';

// void main() {
//   runApp(const MyApp());
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/builder/:sessionUID/:tabUID',
          page: () => MyLandingPage(),
          middlewares: [CustomMiddleware('/builder', hasTabUID: "hasTabUID")],
        ),
        GetPage(
          name: '/builder/:sessionUID',
          page: () => MyLandingPage(),
          middlewares: [CustomMiddleware('/builder', hasTabUID: "noTabUID")],
        ),
        GetPage(
          name: '/redirect',
          page: () => RedirectTest(),
        ),
      ],
    );
  }
}

class RedirectTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redirect Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/builder/1234');
          },
          child: Text('Redirect to Builder'),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            String sessionUID = "1234";
            Get.toNamed('/builder/$sessionUID');
          },
          child: Text('Login and Go to Builder'),
        ),
      ),
    );
  }
}

class MyLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Landing Page')),
      body: Center(
        child: Text(
          'Session UID: ${Get.parameters['sessionUID']}\n'
          'Tab UID: ${Get.parameters['tabUID'] ?? "No Tab UID"}',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  final String? baseRoute;
  final String? hasTabUID;

  CustomMiddleware(this.baseRoute, {this.hasTabUID});

  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    if (true) {
      return RouteDecoder.fromRoute('/redirect');
    }
    // print("get.parameters: ${Get.parameters}");
    // print('routeparas: ${route.parameters}');
    // if (route.parameters.containsKey('sessionUID')) {
    //   String sessionUID = route.parameters['sessionUID']!;
    //   if (route.parameters.containsKey('tabUID')) {
    //     print('dsjdsdsds');
    //     return null; // Tab UID is already present, no need to redirect
    //   }
    //   // Generate a new Tab UID

    //   String tabUID = "323232";
    //   print('qqqqqqqqqqq');
    //   // Redirect to the route with both sessionUID and tabUID
    //   return RouteDecoder.fromRoute('$baseRoute/$sessionUID/$tabUID');
    // }

    // print('aaaaaaaaaa');
    // return await super.redirectDelegate(route);
  }
}

 


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

// /// Nav 2 snippet
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       getPages: [
//         GetPage(
//             participatesInRootNavigator: true,
//             name: '/first',
//             page: () => const First()),
//         GetPage(
//           name: '/second',
//           page: () => const Second(),
//           transition: Transition.downToUp,
//         ),
//         GetPage(
//           name: '/third',
//           page: () => const Third(),
//         ),
//       ],
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class FirstController extends GetxController {
//   @override
//   void onClose() {
//     print('on close first');
//     super.onClose();
//   }
// }

// class First extends StatelessWidget {
//   const First({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print('First rebuild');
//     Get.put(FirstController());
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('page one'),
//         leading: IconButton(
//           icon: const Icon(Icons.more),
//           onPressed: () {
//             Get.snackbar(
//               'title',
//               "message",
//               mainButton:
//                   TextButton(onPressed: () {}, child: const Text('button')),
//               isDismissible: true,
//               duration: Duration(seconds: 5),
//               snackbarStatus: (status) => print(status),
//             );
//             // print('THEME CHANGED');
//             // Get.changeTheme(
//             //     Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
//           },
//         ),
//       ),
//       body: Center(
//         child: SizedBox(
//           height: 300,
//           width: 300,
//           child: ElevatedButton(
//             onPressed: () {
//               Get.toNamed('/second?id=123');
//             },
//             child: const Text('next screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SecondController extends GetxController {
//   final textEdit = TextEditingController();
//   @override
//   void onClose() {
//     print('on close second');
//     textEdit.dispose();
//     super.onClose();
//   }
// }

// class Second extends StatelessWidget {
//   const Second({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SecondController());
//     print('second rebuild');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('page two ${Get.parameters["id"]}'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Expanded(
//                 child: TextField(
//               controller: controller.textEdit,
//             )),
//             SizedBox(
//               height: 300,
//               width: 300,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text('next screen'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Third extends StatelessWidget {
//   const Third({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red,
//       appBar: AppBar(
//         title: const Text('page three'),
//       ),
//       body: Center(
//         child: SizedBox(
//           height: 300,
//           width: 300,
//           child: ElevatedButton(
//             onPressed: () {},
//             child: const Text('go to first screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }
