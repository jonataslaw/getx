import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.nestedKey(Routes.home),
      builder: (context) {
        final delegate = context.navigation;
        //This router outlet handles the appbar and the bottom navigation bar
        final currentLocation = context.location;
        print(currentLocation);
        var currentIndex = 0;
        if (currentLocation.startsWith(Routes.products) == true) {
          currentIndex = 2;
        }
        if (currentLocation.startsWith(Routes.profile) == true) {
          currentIndex = 1;
        }
        return Scaffold(
          body: GetRouterOutlet(
            initialRoute: Routes.dashboard,
            anchorRoute: Routes.home,

            //delegate: Get.nestedKey(Routes.HOME),
            // key: Get.nestedKey(Routes.HOME),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  delegate.toNamed(Routes.home);
                  break;
                case 1:
                  delegate.toNamed(Routes.profile);
                  break;
                case 2:
                  delegate.toNamed(Routes.products);
                  break;
                default:
              }
            },
            items: [
              // _Paths.HOME + [Empty]
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              // _Paths.HOME + Routes.PROFILE
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: 'Profile',
              ),
              // _Paths.HOME + _Paths.PRODUCTS
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: 'Products',
              ),
            ],
          ),
        );
      },
    );
  }
}
