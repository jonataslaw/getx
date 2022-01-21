import 'dart:collection';

import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/LeagueStuff/participant.dart';
import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:get/get.dart';
import '../../../../services/globals.dart';
import '../../our_controller.dart';

class ProfileController extends OurController {
  final myNameAndLevel = "3".obs;
  final updateText = "Updating hasnt started yet".obs;
  late Summoner summoner = Summoner();
  List<dynamic> matchOverviews = [];
  List<dynamic> matchOverviewsToSearch = [];
  Set<Match> matches = {};

  @override
  Future<void> onReady() async {
    super.onReady();
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
    matchOverviews =
        await league.getMatchesFromDb("${summoner.puuid}", allMatches: false);
    print("Finished getting ${matchOverviews.length} matches");
    if (matchOverviews.length > 0) {
      matchOverviewsToSearch.addAll(matchOverviews);
      final matchIdToSearch = matchOverviewsToSearch.first;
      matchOverviewsToSearch.remove(matchIdToSearch);
      startSearchingMatches(matchIdToSearch as String);
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

  Map<String, int> map1 = {};
  void _findWhoIAm() {
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
  }
}
