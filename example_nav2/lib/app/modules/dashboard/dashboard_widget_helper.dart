import 'package:dart_lol/dart_lol_api.dart';
import 'package:dart_lol/helper/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';
import 'controllers/dashboard_controller.dart';
import 'dashboard_text_helper.dart';

Widget returnMostPlayedChampions(DashboardController controller) {
  return ListView.builder(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: controller.matchItems.length,
    itemBuilder: (context, index) {
      if (controller.matchItems.isEmpty){
        return returnLoadingIndicator();
      }else {
        return FittedBox(
          fit: BoxFit.fill,
          child: IntrinsicHeight(
            child: Container(margin: EdgeInsets.fromLTRB(12.0, 0, 0.0, 0), child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.matchItems[index].championName),
                  Image.network("${controller.matchItems[index].imageUrl}", height: 30,),
                  Text("${controller.matchItems[index].wins}-${controller.matchItems[index].losses}")
                ])
            ),
          ),
        );
      }
    },
  );
}

Widget returnHighestWinRateChampions(DashboardController controller) {
  return ListView.builder(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: controller.highestWinRate.length,
    itemBuilder: (context, index) {
      return FittedBox(
        fit: BoxFit.fill,
        child: IntrinsicHeight(
          child: Container(margin: EdgeInsets.fromLTRB(12.0, 0, 0.0, 0), child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.highestWinRate[index].championName),
                Image.network("${controller.highestWinRate[index].imageUrl}"),

                Text("${controller.highestWinRate[index].wins}-${controller.highestWinRate[index].losses}")
              ])
          ),
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
          return returnLoadingIndicator();
        }else if (snapshot.connectionState == ConnectionState.done) {
          var tempImage = urlHelper.buildChampionImage("LeeSin.png");
          if(snapshot.hasData) {
            tempImage = snapshot.requireData;
          }else {
            print("we have no data, using Lee Sin as default");
          }
          return
            FutureBuilder<PaletteGenerator>(
                future: controller.updatePaletteGenerator(tempImage), // async work
                builder: (BuildContext context, AsyncSnapshot<PaletteGenerator> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return Center(child:CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final lightVibrant = snapshot.data?.lightVibrantColor?.color??Colors.blue;
                        final darkVibrant = snapshot.data?.darkVibrantColor?.color??Colors.blue;
                        return returnElevatedBoxRoundedCorners(Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              returnItemDetailText("#${controller.challengerPlayers.indexOf(controller.challengerPlayersFiltered[index])+1}", lightVibrant),
                              returnItemDetailText("${controller.challengerPlayersFiltered[index].summonerName}", lightVibrant),
                              returnItemDetailText("${controller.challengerPlayersFiltered[index].leaguePoints} LP", lightVibrant),
                              Image.network(tempImage),
                              returnItemDetailText("${controller.challengerPlayersFiltered[index].wins}-${controller.challengerPlayersFiltered[index].losses}", lightVibrant),
                            ]
                        ), darkVibrant);
                      }}});

        }else {
          return returnLoadingIndicator();
        }
      },
  );
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

Widget returnElevatedBoxRoundedCorners(Widget widget, Color backgroundColor) {
  return IntrinsicHeight(
      child: FittedBox(
      fit: BoxFit.fitHeight,
      child: Card(
        elevation: 8,
        color: backgroundColor,
        shadowColor: Colors.blue,
        child: Container(
        decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
        Radius.circular(12.0),),),
        margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0), child: widget))));
}

Widget returnLoadingIndicator() {
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