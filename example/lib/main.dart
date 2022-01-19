import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'lang/translation_service.dart';
import 'routes/app_pages.dart';
import 'shared/logger/logger_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final routerDelegate = GetNavigation.instance = GetNavigation(
    pages: AppPages.routes,
    navigatorObservers: [GetObserver()],
  );

  final routeInformationParser =
      NewGetInformationParser(initialRoute: AppPages.INITIAL);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      // title: 'Router Management Example',
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      // initialRoute: AppPages.INITIAL,
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
