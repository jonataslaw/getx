import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        //This router outlet handles the appbar and the bottom navigation bar
        final currentLocation = currentRoute?.location;
        var currentIndex = 0;
        if (currentLocation?.startsWith(Routes.PRODUCTS) == true) {
          currentIndex = 2;
        }
        if (currentLocation?.startsWith(Routes.PROFILE) == true) {
          currentIndex = 1;
        }
        return Scaffold(
          body: GetRouterOutlet(
            initialRoute: Routes.DASHBOARD,
            // name: Routes.HOME,
            //It's preferable to use emptyPage instead of emptyWidget
            // emptyPage: (delegate) =>
            //     Get.routeTree.matchRoute(Routes.DASHBOARD).route!,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  delegate.toNamed(Routes.HOME);
                  break;
                case 1:
                  delegate.toNamed(Routes.PROFILE);
                  break;
                case 2:
                  delegate.toNamed(Routes.PRODUCTS);
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
