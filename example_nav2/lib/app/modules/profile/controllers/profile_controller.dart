import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:get/get.dart';
import '../../../../services/globals.dart';
import '../../our_controller.dart';

class ProfileController extends OurController {

  final myNameAndLevel = "3".obs;
  late Summoner summoner = Summoner();
  List<dynamic> matchOverviews = [];
  List<dynamic> matchOverviewsToSearch = [];
  Set<Match> matches = {};

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  void searchChampion() async {
    var summonerResponse = await league.getSummonerInfo('Where YoGradesAt');
    if (summonerResponse.summoner.runtimeType == Summoner) {
      summoner = summonerResponse.summoner as Summoner;
      searchMatchList();
    } else {
      checkError("error: ${summonerResponse.responseCode}");
    }
  }

  void searchMatchList() async {
    matchOverviews = await league.getMatchesFromDb("${summoner.puuid}", allMatches: false);
    print("Finished getting ${matchOverviews.length} matches");
    if (matchOverviews.length > 0) {
      matchOverviewsToSearch.addAll(matchOverviews);
      final matchIdToSearch = matchOverviewsToSearch.first;
      matchOverviewsToSearch.remove(matchIdToSearch);
      startSearchingMatches(matchIdToSearch as String);
    }
  }

  void startSearchingMatches(String matchId) async {
    var leagueResponse = await league.getMatch(matchId, fallbackAPI: true);
    if(leagueResponse.match != null) {
      matches.add(leagueResponse.match!);
      if(matchOverviewsToSearch.isNotEmpty) {
        final matchIdToSearch = matchOverviewsToSearch.removeLast();
        print("There are ${matchOverviewsToSearch.length} left to search");
        startSearchingMatches(matchIdToSearch as String);
      }else {
        print("We've reached the end of the list");
        myNameAndLevel.value = "There are ${matches.length} matches";
      }
    }else {
      print("Error Check");
    }
  }
}
