
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../routes/app_pages.dart';
import 'controllers/dashboard_controller.dart';

SizedBox returnHorizontalChallengerListView(DashboardController controller) {
  return SizedBox(
    height: 120,
    child:
      Obx(() => ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.challengerPlayers.length,
      itemBuilder: (context, index) => _buildBox(color: Colors.orange, controller: controller, index: index),
      )),
  );
  // return ListView.builder(
  //     physics: ClampingScrollPhysics(),
  //     shrinkWrap: true,
  //     scrollDirection: Axis.horizontal,
  //     itemCount: controller.challengerPlayers.length,
  //     itemBuilder: (context, index) {
  //       final item = controller.challengerPlayers[index];
  //       return ListTile(
  //         onTap: () {
  //           Get.rootDelegate.toNamed(Routes.SETTINGS);
  //         },
  //         title: Text("${item.summonerId} and ${item.summonerName} damage"),
  //         tileColor: Colors.red,
  //         subtitle: Text("${item.freshBlood} as ${item.inactive} "),
  //       );
  //     });
}
Widget _buildBox({required Color color, required DashboardController controller, required int index}) {
  return Container(margin: EdgeInsets.all(12), height: 100, width: 200, color: color, child: Text("${controller.challengerPlayers[index].summonerName}"));
}
