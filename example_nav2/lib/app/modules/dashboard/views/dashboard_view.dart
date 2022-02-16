import 'package:dart_lol/dart_lol_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../dashboard_widget_helper.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Obx(() => SingleChildScrollView(
          child:
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(6.0, 0, 20.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRankedSelectionTool(controller),
                    ],
                  ),
                ),
                buildSearchRankedPlayersFilter(controller),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 200.0,
                  child: returnHorizontalChallengerListView(controller)
                ),

                ///Most played champions
                Text("Most played champions"),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: 200.0,
                    child: returnMostPlayedChampions(controller),
                ),



                ///highest winrate champions
                Text("Highest winrate champions"),



                ]
          )
        ))
    );
  }
}
