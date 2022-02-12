
import 'package:dart_lol/dart_lol_api.dart';
import 'package:flutter/cupertino.dart';
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
      ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.challengerPlayers.length,
        itemBuilder: (context, index) {
          //find most played champion
          //find color of that champion
          //find opposite color for the text color
          return _buildChampionHorizontalList(color: Colors.orange, controller: controller, index: index);
        },
      ),
  );
}

Widget _buildChampionHorizontalList({required Color color, required DashboardController controller, required int index}) {
  print("$index");

  ///get summoner
  ///get matches
  ///get last 5 matches
  // final rankedPlayer = controller.challengerPlayers[index];
  // final s = await controller.getSummoner(false, rankedPlayer.summonerName??"");
  // final matchHistories = await controller.getMatchHistories(false, s?.puuid??"");
  // final myMathces = [];
  // matchHistories?.take(5).forEach((element) {
  //   final m = controller.getMatch(element);
  //   myMathces.add(m);
  // });

  return Container(
      margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0), height: 100, width: 200, color: color, child:
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("${controller.challengerPlayers[index].summonerName}"),
      Text("${controller.challengerPlayers[index].leaguePoints} LP"),
      Image.network("${controller.userProfileImage}"),
      Text("${controller.challengerPlayers[index].wins}-${controller.challengerPlayers[index].losses}")
    ]
  ));
}


Widget buildRankedSelectionTool(DashboardController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      /// Tiers
      Container(
        margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
        child: DropdownButton<String>(
          value: controller.tiersDropdownValue.value,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.red, fontSize: 18),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? data) {
            print(data);
            controller.tiersDropdownValue.value = data??TiersHelper.getValue(Tier.CHALLENGER);
          },
          items: controller.tiersItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),

      ///Queues
      Container(
      margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
      child: DropdownButton<String>(
        value: controller.queuesDropdownValue.value,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.red, fontSize: 18),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? data) {
          print(data);
          controller.queuesDropdownValue.value = data??QueuesHelper.getValue(Queue.RANKED_SOLO_5X5);
        },
        items: controller.queuesItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )),
      ///Division
      Container(
      margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
      child: DropdownButton<String>(
        value: controller.divisionsDropdownValue.value,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.red, fontSize: 18),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? data) {
          print(data);
          controller.divisionsDropdownValue.value = data??DivisionsHelper.getValue(Division.I);
        },
        items: controller.divisionsItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )),


    ],
  );
}