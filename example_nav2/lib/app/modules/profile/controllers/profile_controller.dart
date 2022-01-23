
import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:dart_lol/ddragon_api.dart';
import 'package:dart_lol/ddragon_storage.dart';
import 'package:dart_lol/helper/UrlHelper.dart';
import 'package:example_nav2/models/match_item.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../services/globals.dart';
import '../../our_controller.dart';

class ProfileController extends OurController {
  final myNameAndLevel = "3".obs;
  String imageUrl = "";
  final updateText = "Updating hasnt started yet".obs;
  late Summoner summoner = Summoner();
  Map<String, int> map1 = {};
  List<String> matchOverviews = <String>[];
  List<String> matchOverviewsToSearch = <String>[];
  Set<Match> matches = {};

  final matchItems = <MatchItem>[].obs;

  @override
  Future<void> onReady() async {
    super.onReady();

    loadMatchItemsFromSomewhere();
  }

  void loadMatchItemsFromSomewhere() {
    matchItems.add(MatchItem(imageUrl: "https://picsum.photos/250?image=9", kda: "133.7", timeAgo: "6 hours ago"));
  }

  void searchChampion() async {
    updateText.value = "Searching for champion Where YoGradesAt";
    var summonerResponse = await league.getSummonerInfo('Where YoGradesAt');
    if (summonerResponse.summoner.runtimeType == Summoner) {
      summoner = summonerResponse.summoner as Summoner;
      searchMatchList();
    } else {
      checkError(summonerResponse);
    }
  }

  void searchMatchList() async {
    updateText.value = "Searching match histories";
    final tempMatchOverviews = await league.getMatchesFromDb("${summoner.puuid}", allMatches: false);

    tempMatchOverviews.forEach((element) {
      matchOverviews.add(element as String);
    });

    print("Finished getting ${matchOverviews.length} matches");
    if (matchOverviews.length > 0) {
      matchOverviewsToSearch.addAll(matchOverviews.take(25));
      final matchIdToSearch = matchOverviewsToSearch.first;
      matchOverviewsToSearch.remove(matchIdToSearch);
      matches.clear();
      //startSearchingMatches(matchIdToSearch as String);

      final that = await UrlHelper().getRiotGamesAPIVersion();
      print("The version is: ${that}");

      final whoKnows = DDragonStorage().getRiotGamesAPIVersion();
      final lastUpdated = DDragonStorage().getVersionsLastUpdated();
      print("It was last updated ${timeago.format(DateTime.fromMillisecondsSinceEpoch(lastUpdated))}");
      print(whoKnows);

      //final champions = await DDragonAPI().getChampionsFromApi();
      //print(champions.toJson());

      final championsDB = await DDragonStorage().getChampionsFromDb();
      print(championsDB.version);

      final aatrox = championsDB.data?.entries.firstWhere((element) => element.value.name == "Aatrox");
      print("${aatrox?.value.name}");

      final aatroxImage = await UrlHelper().buildChampionImage(aatrox?.value.image?.full??"Aatrox.png");
      imageUrl = aatroxImage;
      print(aatroxImage);
    }
  }

  void startSearchingMatches(String matchId) async {
    updateText.value = "Searching match $matchId";
    var leagueResponse = await league.getMatch(matchId, fallbackAPI: true);
    if (leagueResponse.match != null) {
      matches.add(leagueResponse.match!);
      if (matchOverviewsToSearch.isNotEmpty) {
        final matchIdToSearch = matchOverviewsToSearch.removeLast();
        print("There are ${matchOverviewsToSearch.length} left to search");
        startSearchingMatches(matchIdToSearch as String);
      } else {
        print("We've reached the end of the list");
        myNameAndLevel.value = "Done, there are ${matches.length} matches";
        Get.snackbar("Finished Searching all matches",
            "There should be ${matches.length}");
        _findWhoIAm();
      }
    } else {
      checkError(leagueResponse);
    }
  }

  void _findWhoIAm() {
    map1.clear();
    matches.forEach((element) {
      element.info?.participants?.forEach((p) {
        if (map1.containsKey(p.summonerName)) {
          map1.update(p.summonerName ?? "", (value) => value + 1);
        } else {
          map1.putIfAbsent(p.summonerName ?? "", () => 1);
        }
        if (p.puuid == summoner.puuid) {
          print("We had ${p.kills} kills");
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
