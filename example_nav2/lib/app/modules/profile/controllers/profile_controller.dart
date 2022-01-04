import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/LeagueStuff/summoner.dart';
import 'package:get/get.dart';
import '../../../../services/globals.dart';

class ProfileController extends GetxController {

  final myNameAndLevel = "0".obs;
  late Summoner summoner = Summoner();
  List<dynamic> matchOverviews = [];
  List<Match> matches = [];

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  void searchChampion() async {
    var summonerResponse = await league.getSummonerInfo('Where YoGradesAt');
    if (summonerResponse.summoner.runtimeType == Summoner) {
      summoner = summonerResponse.summoner as Summoner;
      myNameAndLevel.value = "${summoner.name} and ${summoner.summonerLevel}";
      searchMatchList();
    } else {
      print("error: ${summonerResponse.responseMessage}");
    }
  }

  void searchMatchList() async {
    matchOverviews = await league.getMatchesFromDb("${summoner.puuid}", allMatches: false);
    print("Finished getting matches ${matchOverviews.length}");
    if (matchOverviews.length > 0) {
      searchParticularMatch("NA1_4056249988");
    }
  }

  void searchParticularMatch(String matchId) async {
    var leagueResponse = await league.getMatch(matchId, fallbackAPI: true);
    if(leagueResponse.match != null) {
      matches.add(leagueResponse.match!);
      myNameAndLevel.value = "${leagueResponse.match?.metadata?.matchId}";
    }
  }

  void getNextMatch(String matchId) async {
    var match = await league.getMatch(matchId, fallbackAPI: true);

  }
}
