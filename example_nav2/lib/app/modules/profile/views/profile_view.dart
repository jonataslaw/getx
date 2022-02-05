import 'package:example_nav2/app/modules/profile/profile_widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body:
      SingleChildScrollView(
        child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => Image.network("${controller.userProfileImage}",
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,)),
              MaterialButton(
                child: Text(
                  'search champion where yo gradesat !!',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                onPressed: () {
                  controller.searchSummoner();
                },
              ),
              Obx(() => Text("${controller.updateText}")),
              Hero(
                tag: 'heroLogo',
                child: const FlutterLogo(),
              ),
              MaterialButton(
                child: Text('Show a test dialog'),
                onPressed: () {
                  //shows a dialog
                  Get.defaultDialog(
                    title: 'Test Dialog !!',
                    barrierDismissible: true,
                  );
                },
              ),
              MaterialButton(
                child: Obx(() => Text("${controller.myNameAndLevel}")),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Test Dialog In Home Outlet !!',
                    barrierDismissible: true,
                    navigatorKey: Get.nestedKey(Routes.HOME),
                  );
                },
              ),
              returnColumnLineGraph(controller),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 0,
                color: Colors.blue,
              ),
              returnColumnChartMostPlayedWithFriend(controller),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 0,
                color: Colors.blue,
              ),
              Obx(() => returnListView(controller))
            ],
          ),
      ),
    );
  }
}

class KDAData {
  KDAData(this.champion, this.kda);
  final String champion;
  final double kda;
}
