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

// Navigator 2 example, WIP
// TODO: add all methods from NavigatorExtension to GetNav

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   final getNav = Get.put(
//     GetNav(pages: [
//       GetPage(name: '/first', page: () => First()),
//       GetPage(name: '/second', page: () => Second()),
//       GetPage(name: '/third', page: () => Third()),
//     ]),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routeInformationParser: getNav.routeInformationParser,
//       routerDelegate: getNav.routerDelegate,
//     );
//   }
// }

// class First extends StatelessWidget {
//   final GetNav getNav = Get.find();

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
//             onPressed: () {
//               getNav.toNamed('/second?id=584305');
//             },
//             child: Text('next screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Second extends StatelessWidget {
//   final GetNav getNav = Get.find();
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
//             onPressed: () {
//               getNav.toNamed('/third');
//             },
//             child: Text('next screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Third extends StatelessWidget {
//   final GetNav getNav = Get.find();
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
//             onPressed: () {
//               getNav.offUntil('/first');
//             },
//             child: Text('go to first screen'),
//           ),
//         ),
//       ),
//     );
//   }
// }
