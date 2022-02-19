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
        SingleChildScrollView(
          child:
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(6.0, 0, 20.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => buildRankedSelectionTool(controller),)
                    ],
                  ),
                ),
                Obx(() => buildSearchRankedPlayersFilter(controller)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  height: 150.0,
                  child: Obx(() => returnHorizontalRankedPlayers(controller))
                ),

                ///Most played champions
                Text("Most played champions"),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: 125.0,
                    child: Obx(() => returnMostPlayedChampions(controller)),
                ),

                ///highest winrate champions
                Text("Highest winrate champions"),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  height: 125.0,
                  child: Obx(() => returnHighestWinRateChampions(controller)),
                ),
                Container(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(20),
                    child: FittedBox(
                      child: IconButton(
                        onPressed: () {
                          controller.getSummonerFromDb();
                        },
                        icon: Icon(Icons.search_sharp),
                      ),
                    ),
                  ),
                )


                ]
          )
        )
    );
  }
}
