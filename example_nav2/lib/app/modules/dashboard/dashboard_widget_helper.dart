
import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/dart_lol_api.dart';
import 'package:dart_lol/helper/url_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_it/get_it.dart';

import '../../routes/app_pages.dart';
import 'controllers/dashboard_controller.dart';

Widget returnMostPlayedChampions(DashboardController controller) {
  return ListView.builder(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: controller.matchItems.length,
    itemBuilder: (context, index) {
      var urlHelper = GetIt.instance<UrlHelper>();
      return IntrinsicHeight(
        child: Container(margin: EdgeInsets.fromLTRB(12.0, 0, 0.0, 0), child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${controller.matchItems[index].championName}"),
              Image.network("${controller.matchItems[index].imageUrl}"),
              Text("${controller.matchItems[index].wins}-${controller.matchItems[index].losses}")
            ])
        ),
      );
    },
  );
}

Widget returnHorizontalRankedPlayers(DashboardController controller) {
  return ListView.builder(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: controller.challengerPlayersFiltered.length,
    itemBuilder: (context, index) {
      //find most played champion
      //find color of that champion
      //find opposite color for the text color
      return _buildChampionHorizontalList(color: Colors.orange, controller: controller, index: index);
    },
  );
}

Widget _buildChampionHorizontalList({required Color color, required DashboardController controller, required int index}) {
  var urlHelper = GetIt.instance<UrlHelper>();
  return FutureBuilder<String>(
      future: controller.getMatchesForRankedSummoner(index),
      initialData: urlHelper.buildChampionImage("LeeSin.png"),
      builder: (
          BuildContext context,
          AsyncSnapshot<String> snapshot,) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ],
          );
        }else if (snapshot.connectionState == ConnectionState.done) {
          var tempImage = urlHelper.buildChampionImage("LeeSin.png");
          if(snapshot.hasData) {
            tempImage = snapshot.requireData;
          }else {
            print("we have no data, using Lee Sin as default");
          }
          return IntrinsicHeight(
            child: Container(margin: EdgeInsets.fromLTRB(12.0, 0, 0.0, 0), color: color, child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("#${controller.challengerPlayers.indexOf(controller.challengerPlayersFiltered[index])+1}"),
                  Text("${controller.challengerPlayersFiltered[index].summonerName}"),
                  Text("${controller.challengerPlayersFiltered[index].leaguePoints} LP"),
                  Image.network(tempImage),
                  Text("${controller.challengerPlayersFiltered[index].wins}-${controller.challengerPlayersFiltered[index].losses}")
                ]
            )),
          );
        }else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ],
          );
        }
      },
  );

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

  // return Container(
  //     margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0), height: 100, width: 200, color: color, child:
  // Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: [
  //     Text("${controller.challengerPlayers[index].summonerName}"),
  //     Text("${controller.challengerPlayers[index].leaguePoints} LP"),
  //     Image.network("${controller.userProfileImage}"),
  //     Text("${controller.challengerPlayers[index].wins}-${controller.challengerPlayers[index].losses}")
  //   ]
  // ));
}

Widget buildSearchRankedPlayersFilter(DashboardController controller) {
  return Container(
    margin: EdgeInsets.fromLTRB(4.0, 0, 0.0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(visible: controller.showRankedSearchFilter.value,
          child: Expanded(child: TextFormField(
            onChanged: (text) {
              controller.filterChallengerPlayers(text);
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Filter by summoner name',
            ),
          ),),
        ),
        buildSortByDropdown(controller),
      ],
    ),
  );
}

Widget buildSortByDropdown(DashboardController controller) {
  return Container(
      margin: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
      child: DropdownButton<String>(
        value: controller.sortByDropdownValue.value,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.red, fontSize: 14),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? data) {
          print(data);
          controller.sortByDropdownValue.value = data??SortByHelper.getValue(SortBy.LP);
          controller.sortRankedPlayers();
        },
        items: controller.sortByItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ));
}


Widget buildRankedSelectionTool(DashboardController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      /// Tiers
      Container(
        margin: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
        child: DropdownButton<String>(
          value: controller.tiersDropdownValue.value,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.red, fontSize: 14),
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
      margin: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
      child: DropdownButton<String>(
        value: controller.queuesDropdownValue.value,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.red, fontSize: 14),
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
      margin: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
      child: DropdownButton<String>(
        value: controller.divisionsDropdownValue.value,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.red, fontSize: 14),
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
      /// Show/Hide icon
      Container(
       child: SizedBox.fromSize(
         size: Size.fromRadius(20),
         child: FittedBox(
           child: IconButton(
             onPressed: () {
               controller.pressedSearchButton();
             },
             icon: Icon(Icons.search_sharp),
           ),
         ),
       ),
      )
    ],
  );
}
