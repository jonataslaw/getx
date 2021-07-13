import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lang/translation_service.dart';
import 'routes/app_pages.dart';
import 'shared/logger/logger_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
    );
  }
}

/// Nav 2 snippet
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp.router(
//       getPages: [
//         GetPage(
//             participatesInRootNavigator: true,
//             name: '/first',
//             page: () => First()),
//         GetPage(
//           name: '/second',
//           page: () => Second(),
//         ),
//         GetPage(
//           name: '/third',
//           page: () => Third(),
//         ),
//       ],
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class First extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('page one'),
//         leading: IconButton(
//           icon: Icon(Icons.more),
//           onPressed: () {
//             Get.changeTheme(
//                 context.isDarkMode ? ThemeData.light() : ThemeData.dark());
//           },
//         ),
//       ),
//       body: Center(
//         child: Container(
//           height: 300,
//           width: 300,
//           child: ElevatedButton(
//             onPressed: () {},
//             child: Text('next screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Second extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('page two ${Get.parameters["id"]}'),
//       ),
//       body: Center(
//         child: Container(
//           height: 300,
//           width: 300,
//           child: ElevatedButton(
//             onPressed: () {},
//             child: Text('next screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Third extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red,
//       appBar: AppBar(
//         title: Text('page three'),
//       ),
//       body: Center(
//         child: Container(
//           height: 300,
//           width: 300,
//           child: ElevatedButton(
//             onPressed: () {},
//             child: Text('go to first screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }
