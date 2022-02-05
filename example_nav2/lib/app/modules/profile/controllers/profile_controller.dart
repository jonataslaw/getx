
import 'package:dart_lol/LeagueStuff/champions.dart';

import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:example_nav2/app/helpers/matches_helper.dart';
import 'package:example_nav2/app/modules/profile/views/profile_view.dart';
import 'package:example_nav2/models/match_item.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../services/globals.dart';
import '../../our_controller.dart';

class ProfileController extends OurController {
  ///User update stuff
  final updateText = "Updating hasnt started yet".obs;
  final myNameAndLevel = "3".obs;
  /// Summoner stuff
  RxString userProfileImage = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ezreal_1.jpg".obs;
  Map<String, int> map1 = {};

  final matchItems = <MatchItem>[].obs;
  /// Database stuff
  late Champions championsDB;

  /// Chart stuff
  ChartSeriesController? chartSeriesController;

  // var salesData = <SalesData>[
  //   SalesData('Jan', 35),
  //   SalesData('Feb', 28),
  //   SalesData('Mar', 34),
  //   SalesData('Apr', 32),
  //   SalesData('May', 40)
  // ].obs;

  var salesData = <SalesData>[
    SalesData('May', 30)
  ].obs;

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  void searchSummoner() async {
    updateText.value = "Searching for champion Where YoGradesAt";
    await getSummoner(true, 'Where YoGradesAt');
    userProfileImage.value = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Fizz_1.jpg";

    //salesData.add(SalesData('May', 30));
    //chartSeriesController?.updateDataSource(addedDataIndex: salesData.length - 1);
    //chartSeriesController?.updateDataSource(updatedDataIndex: 0);
    salesData.add(SalesData('June', 90));
    chartSeriesController?.updateDataSource(addedDataIndex: salesData.length - 1);

    searchMatchHistories();
  }

  void searchMatchHistories() async {
    updateText.value = "Searching match histories";
    await getMatchHistories(true, "${summoner?.puuid}", allMatches: false, fallbackAPI: true, start: 0, count: 25);
    print("Finished getting ${matchOverviews?.length} matches");

    matchOverviewsToSearch?.addAll(matchOverviews?.take(25)??<String>[]);
    final matchIdToSearch = matchOverviewsToSearch?.first;
    matchOverviewsToSearch?.remove(matchIdToSearch);

    final whoKnows = await dDragonStorage.getVersionFromDb();
    final lastUpdated = dDragonStorage.getVersionsLastUpdated();
    print("It was last updated ${timeago.format(DateTime.fromMillisecondsSinceEpoch(lastUpdated))}");
    print(whoKnows);

    championsDB = await dDragonStorage.getChampionsFromDb();
    print(championsDB.version);

    final aatrox = championsDB.data?.entries.firstWhere((element) => element.value.name == "Aatrox");
    print("${aatrox?.value.name}");

    final aatroxImage = await urlHelper.buildChampionImage(aatrox?.value.image?.full??"Aatrox.png");
    print(aatroxImage);

    startSearchingMatches(matchIdToSearch as String);
  }

  void startSearchingMatches(String matchId) async {
    updateText.value = "Searching match $matchId";
    var leagueResponse = await league.getMatch(matchId, fallbackAPI: true);
    if (leagueResponse.match != null) {
      matches.add(leagueResponse.match!);
      if (matchOverviewsToSearch?.isNotEmpty == true) {
        final matchIdToSearch = matchOverviewsToSearch?.removeLast();
        print("There are ${matchOverviewsToSearch?.length} left to search");
        startSearchingMatches(matchIdToSearch as String);
      } else {
        print("We've reached the end of the list");
        myNameAndLevel.value = "Done, there are ${matches.length} matches";
        Get.snackbar("Finished Searching all matches",
            "There should be ${matches.length}");
        updateText.value = "Finished searching ${matches.length} matches";
        findWhoIAm();
      }
    } else {
      checkError(leagueResponse);
    }
  }

  void findWhoIAm() {
    map1.clear();
    matches.forEach((element) {
      element.info?.participants?.forEach((p) async {
        if (map1.containsKey(p.summonerName)) {
          map1.update(p.summonerName ?? "", (value) => value + 1);
        } else {
          map1.putIfAbsent(p.summonerName ?? "", () => 1);
        }
        if (p.puuid == summoner?.puuid) {
          print("We had ${p.kills} kills");
          final mChampionId = p.championId;
          final mChamion = championsDB.data?.entries.firstWhere((element) => element.value.key == "${mChampionId}");

          print("I played ${mChamion?.value.name}");
          var kills = p.kills??0;
          var deaths = p.deaths??1;
          if(deaths == 0) {
            deaths = 1;
          }
          final assists = p.assists??0;
          final kda = ((kills + assists) / deaths).toStringAsFixed(2);
          final timeAgo = timeago.format(DateTime.fromMillisecondsSinceEpoch(element.info?.gameCreation??DateTime.now().millisecondsSinceEpoch));

          final image = await urlHelper.buildChampionImage(mChamion?.value.image?.full??"Aatrox.png");
          matchItems.add(MatchItem(imageUrl: image, kda: "$kda KDA", timeAgo: "$timeAgo"));
        }
      });
    });
    //print(map1);
    final sortedEntries = map1.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) diff = e2.key.compareTo(e1.key);
        return diff;
      });

    print(sortedEntries);

    _findMyMostRecentGame();
  }

  void _findMyMostRecentGame() {
    final l = matches.toList();
    l.sort((a,b) => a.info?.gameCreation??0.compareTo(b.info?.gameCreation??0) as int);
    final now = DateTime.now();

    for (var element in l) {
      final ts = element.info?.gameCreation??0 * 1000;
      final difference = now.difference(DateTime.fromMillisecondsSinceEpoch(ts));
      final that = now.subtract(difference);
      print(timeago.format(that) + " ${element.info?.gameCreation} for ${element.metadata?.matchId}");
    }
  }
}
