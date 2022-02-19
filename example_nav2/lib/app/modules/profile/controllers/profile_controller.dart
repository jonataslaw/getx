

import 'package:dart_lol/LeagueStuff/champions.dart';

import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:dart_lol/dart_lol_api.dart';
import 'package:example_nav2/app/helpers/matches_helper.dart';
import 'package:example_nav2/app/modules/profile/views/profile_view.dart';
import 'package:example_nav2/models/match_item.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timeago/timeago.dart' as timeago;
import "package:intl/intl.dart";

import '../../../../services/globals.dart';
import '../../our_controller.dart';
import '../profile_widget_helper.dart';

class ProfileController extends OurController {
  ///User update stuff
  final updateText = "Updating hasnt started yet".obs;
  final myNameAndLevel = "3".obs;
  final friendsText = "Most played with friends".obs;
  final mostPlayedChampionsText = "Most played chamoions".obs;
  /// Summoner stuff
  RxString userProfileImage = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ezreal_1.jpg".obs;
  Map<String, int> mapOfMostPlayedWithFriends = {};
  Map<String, int> mapOfMostPlayedChampions = {};

  final matchItems = <MatchItem>[].obs;
  /// Database stuff
  late Champions championsDB;

  /// Chart stuff
  ChartSeriesController? chartSeriesController;
  ChartSeriesController? kdaColumnController;
  ChartSeriesController? damageLineController;
  ChartSeriesController? friendsColumnController;
  ChartSeriesController? mostPlayedChampionsColumnController;
  Labeler labeler = Labeler();
  
  final List<ChartData> kdaDamageData = <ChartData>[
    ChartData(x: 'Jan', yValue1: 0, yValue2: 0),
  ].obs;

  var kdaData = <KDAData>[
    KDAData('Filler', 0.0)
  ].obs;

  var friendsData = <KDAData>[
    KDAData("Imaginatis", 0.0)
  ].obs;

  var mostPlayedChampionsData = <KDAData>[
    KDAData("MF", 0.0)
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
    // kdaData.add(KDAData('June', 90));
    // chartSeriesController?.updateDataSource(addedDataIndex: kdaData.length - 1);

    // final that = await league.getRankedQueueFromAPI(QueuesHelper.getValue(Queue.RANKED_SOLO_5X5), TiersHelper.getValue(Tier.CHALLENGER), DivisionsHelper.getValue(Division.I));
    // print(that?[0]?.summonerName);
    //
    // final whoKnows = league.storage.getChallengerPlayers(DivisionsHelper.getValue(Division.I));
    // print(whoKnows);

    searchMatchHistories();
  }

  void searchMatchHistories() async {
    updateText.value = "Searching match histories";
    await getMatchHistories(true, "${summoner?.puuid}", allMatches: false, fallbackAPI: true, start: 0, count: 100);
    print("Finished getting ${matchOverviews?.length} matches");

    matchOverviewsToSearch?.addAll(matchOverviews?.take(50)??<String>[]);
    final matchIdToSearch = matchOverviewsToSearch?.first;
    matchOverviewsToSearch?.remove(matchIdToSearch);

    final whoKnows = await dDragonStorage.getVersionFromDb();
    final lastUpdated = await dDragonStorage.getVersionsLastUpdated();
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
        startSearchingMatches(matchIdToSearch as String);
      } else {
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

  var maxDamageToChampions = 0.obs;
  void findWhoIAm() {
    mapOfMostPlayedWithFriends.clear();
    var count = 0;
    for (var element in matches) {
      element.info?.participants?.forEach((p) async {
        if (mapOfMostPlayedWithFriends.containsKey(p.summonerName)) {
          mapOfMostPlayedWithFriends.update(p.summonerName ?? "", (value) => value + 1);
        } else {
          if(p.summonerName != summoner?.name) {
            mapOfMostPlayedWithFriends.putIfAbsent(p.summonerName ?? "", () => 1);
          }
        }
        if (p.puuid == summoner?.puuid) {
          /// Most played champions
          if (mapOfMostPlayedChampions.containsKey(p.championName)) {
            mapOfMostPlayedChampions.update(p.championName ?? "", (value) => value + 1);
          } else {
            mapOfMostPlayedChampions.putIfAbsent(p.championName ?? "", () => 1);
          }

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

          final damageToChampions = p.totalDamageDealtToChampions??0;
          if(damageToChampions > maxDamageToChampions.value) {
            maxDamageToChampions.value = damageToChampions;
          }

          final image = urlHelper.buildChampionImage(mChamion?.value.image?.full??"Aatrox.png");
          /// Add data to graph and listview

          matchItems.add(MatchItem(
              imageUrl: image,
              championName: "${mChamion?.value.name}",
              damageDealtToChampions: myNyumberFormatter.returnThousandsWithComma(damageToChampions),
              gameDuration: element.info?.gameDuration??0,
              kda: "$kda KDA",
              timeAgo: timeAgo));

          kdaData.add(KDAData("${mChamion?.value.name}", double.parse(kda)));
          chartSeriesController?.updateDataSource(addedDataIndex: kdaData.length - 1);

          final championLabel = labeler.call("${mChamion?.value.name}", count);
          kdaDamageData.add(ChartData(x: championLabel, yValue1: double.parse(kda), yValue2: damageToChampions.toDouble()));
          kdaColumnController?.updateDataSource(addedDataIndex: kdaDamageData.length - 1);
          damageLineController?.updateDataSource(addedDataIndex: kdaDamageData.length - 1);
        }
      });
      count++;
    }
    kdaDamageData.removeAt(0);

    /// Find my most played with friends
    final sortedFriendsList = mapOfMostPlayedWithFriends.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) diff = e2.key.compareTo(e1.key);
        return diff;
      });

    final topFiveFriends = sortedFriendsList.take(5);
    print(sortedFriendsList);
    for (var element in topFiveFriends) {
      friendsData.add(KDAData(element.key, element.value.toDouble()));
      friendsColumnController?.updateDataSource(addedDataIndex: friendsData.length - 1);
    }
    friendsData.removeAt(0);
    friendsColumnController?.updateDataSource(
      updatedDataIndexes: <int>[friendsData.length - 1],
      removedDataIndexes: <int>[friendsData.length - 1],
    );

    /// Find my most played chamions
    final sortedChampions = mapOfMostPlayedChampions.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) diff = e2.key.compareTo(e1.key);
        return diff;
      });

    final topFiveChampions = sortedChampions.take(5);
    for (var element in topFiveChampions) {
      mostPlayedChampionsData.add(KDAData(element.key, element.value.toDouble()));
      mostPlayedChampionsColumnController?.updateDataSource(addedDataIndex: mostPlayedChampionsData.length - 1);
    }
    mostPlayedChampionsData.removeAt(0);

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

class Labeler {
  final existingLabels = <String>[];

  String call(String championName, int index) {
    int existingCount = existingLabels.where((element) => element == championName).length;
    existingLabels.add(championName);
    return ' ' * existingCount + championName + ' ' * existingCount;
  }
}