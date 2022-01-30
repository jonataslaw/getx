import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/root_controller.dart';
import 'drawer.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return RouterOutlet.builder(
      delegate: Get.nestedKey(null),
      builder: (context) {
        final title = context.location;
        return Scaffold(
          drawer: DrawerWidget(),
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          //body: HomeView(),

          body: GetRouterOutlet(
            initialRoute: Routes.HOME,
            delegate: Get.nestedKey(null),
            anchorRoute: '/',
            filterPages: (afterAnchor) {
              return afterAnchor.take(1);
            },
          ),
        );
      },
    );
  }
}
