import 'package:dart_lol/LeagueStuff/responses/league_response.dart';
import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/ddragon_storage.dart';
import 'package:dart_lol/helper/url_helper.dart';
import 'package:example_nav2/helpers/number_formatter.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../services/globals.dart';

class OurController extends GetxController {
  /// Service Init
  var myNyumberFormatter = GetIt.instance<MyNumberFormatter>();
  /// Storage
  DDragonStorage dDragonStorage = league.urlHelper.dDragonStorage;
  UrlHelper urlHelper = league.urlHelper;
  /// League Stuff
  Summoner? summoner = Summoner();
  List<String>? matchOverviews = <String>[];
  List<String>? matchOverviewsToSearch = <String>[];
  Set<Match> matches = {};

  @override
  void onReady() {
    super.onReady();
  }

  Future<Summoner?> getSummoner(bool fromAPI, String summonerName, {bool fallbackAPI = true}) async {
    if(fromAPI) {
      final leagueResponse = await league.getSummonerFromAPI(summonerName);
      if(leagueResponse.summoner == null) {
        checkError(leagueResponse);
      } else {
        summoner = leagueResponse.summoner;
        return leagueResponse.summoner;
      }
    }else {
      final leagueResponse = await league.getSummonerFromDb(summonerName, fallbackAPI);
      if(leagueResponse?.summoner == null) {
        checkError(leagueResponse);
      } else {
        summoner = leagueResponse?.summoner;
        return leagueResponse?.summoner;
      }
    }
  }

  Future<List<String>?> getMatchHistories(bool fromAPI, String puuid, {int start = 0, int count = 100, bool allMatches = true, bool fallbackAPI = false}) async {
    if(fromAPI) {
      final leagueResponse = await league.getMatchesFromAPI(puuid, start: start, count: count);
      matchOverviews = leagueResponse.matchOverviews;
      return matchOverviews;
    }else {
      final leagueResponse = await league.getMatchesFromDb(puuid, start: start, count: count, allMatches: allMatches, fallBackAPI: fallbackAPI);
      matchOverviews = leagueResponse.matchOverviews;
      return matchOverviews;
    }
  }

  Future<LeagueResponse?> getMatch(String matchId) async {
    return await league.getMatch(matchId);
  }

  void checkError(LeagueResponse? leagueResponse) {
    print("error here");
    Get.defaultDialog(title: "Error from Riot API", middleText: "${leagueResponse?.responseCode}");
  }
}
