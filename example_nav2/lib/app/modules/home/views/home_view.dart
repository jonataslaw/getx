import 'package:example_nav2/app/modules/home/views/dashboard_view.dart';
import 'package:example_nav2/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';
import 'package:get/get_navigation/src/nav2/router_outlet.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        final title = currentRoute?.title;
        final currentName = currentRoute?.name;
        var currentIndex = 0;
        if (currentName?.startsWith(Routes.PRODUCTS) == true) currentIndex = 2;
        if (currentName?.startsWith(Routes.PROFILE) == true) currentIndex = 1;
        return Scaffold(
          appBar: title == null
              ? null
              : AppBar(
                  title: Text(title),
                  centerTitle: true,
                ),
          body: GetRouterOutlet(
            emptyStackPage: (delegate) => DashboardView(),
            pickPages: (currentNavStack) {
              // will take any route after home
              final res = currentNavStack.pickAfterRoute(Routes.HOME);
              print('''RouterOutlet rebuild:
                currentStack: $currentNavStack
                pickedStack: $res''');
              return res;
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              final getDelegate = Get.getDelegate();
              if (getDelegate == null) return;
              switch (value) {
                case 0:
                  getDelegate.offUntil(Routes.HOME);
                  break;
                case 1:
                  getDelegate.toNamed(Routes.PROFILE);
                  break;
                case 2:
                  getDelegate.toNamed(Routes.PRODUCTS);
                  break;
                default:
              }
            },
            items: [
              // Routes.Home + [Empty]
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              // Routes.Home + Routes.Profile
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: 'Profile',
              ),
              // Routes.Home + Routes.Products
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
