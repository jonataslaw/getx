import 'package:palette_generator/palette_generator.dart';
import 'package:dart_lol/LeagueStuff/league_entry_dto.dart';
import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/dart_lol_api.dart';
import 'package:dart_lol/helper/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:example_nav2/app/helpers/list_helper.dart';
import 'package:example_nav2/app/helpers/map_helper.dart';
import 'package:example_nav2/app/helpers/matches_helper.dart';
import 'package:example_nav2/models/match_item.dart';
import 'package:get/get.dart';

import '../../../../services/globals.dart';
import '../../our_controller.dart';

class DashboardController extends OurController {
  RxString userProfileImage = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ezreal_1.jpg".obs;
  final challengerPlayers = <LeagueEntryDto>[].obs;
  final challengerPlayersFiltered = <LeagueEntryDto>[].obs;
  var rankedPlayerFilterText = "nadaa".obs;
  var currentPlayersAndNumberGames = "Challenger players with 50 games".obs;
  var showRankedSearchFilter = false.obs;

  RxString queuesDropdownValue = QueuesHelper.getValue(Queue.RANKED_SOLO_5X5).obs;
  List <String> queuesItems = [
    (QueuesHelper.getValue(Queue.RANKED_SOLO_5X5)),
    (QueuesHelper.getValue(Queue.RANKED_FLEX_SR)),
  ];

  RxString tiersDropdownValue = TiersHelper.getValue(Tier.CHALLENGER).obs;
  List <String> tiersItems = [
    (TiersHelper.getValue(Tier.CHALLENGER)),
    (TiersHelper.getValue(Tier.GRANDMASTER)),
    (TiersHelper.getValue(Tier.MASTER)),
    (TiersHelper.getValue(Tier.DIAMOND)),
    (TiersHelper.getValue(Tier.PLATINUM)),
    (TiersHelper.getValue(Tier.GOLD)),
    (TiersHelper.getValue(Tier.SILVER)),
    (TiersHelper.getValue(Tier.BRONZE)),
    (TiersHelper.getValue(Tier.IRON)),
  ];

  RxString divisionsDropdownValue = DivisionsHelper.getValue(Division.I).obs;
  List <String> divisionsItems = [
    (DivisionsHelper.getValue(Division.I)),
    (DivisionsHelper.getValue(Division.II)),
    (DivisionsHelper.getValue(Division.III)),
    (DivisionsHelper.getValue(Division.IV)),
  ];

  RxString sortByDropdownValue = SortByHelper.getValue(SortBy.LP).obs;
  List <String> sortByItems = [
    (SortByHelper.getValue(SortBy.LP)),
    (SortByHelper.getValue(SortBy.WINS)),
    (SortByHelper.getValue(SortBy.LOSSES)),
    (SortByHelper.getValue(SortBy.NAME))
  ];

  @override
  Future<void> onReady() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      getChallengerPlayers();
    });

    // await Future.delayed(const Duration(seconds: 1), () async {
    //     final dl = await league.getSummonerFromAPI("doublelift");
    //
    //     print(dl.summoner?.name);
    //
    //     final matchH = await league.getMatchesFromAPI(dl.summoner?.puuid??"");
    //
    //     print("${matchH.matchOverviews}");
    //
    // });
    
    super.onReady();
  }

  Future<void> getSummonerFromDb() async {
    final s = await getSummoner(false, "Doublelift", fallbackAPI: false);
    print(s?.name);

    final histories = await getMatchHistories(false, s?.puuid??"", fallbackAPI: false);
    print("${histories?.length}");
  }

  Future<void> getChallengerPlayers() async {
    //final rankedChallengerPlayers = await league.getRankedQueueFromAPI(QueuesHelper.getValue(Queue.RANKED_SOLO_5X5), TiersHelper.getValue(Tier.CHALLENGER), DivisionsHelper.getValue(Division.I));

    final that = await league.getRankedQueueFromDb(QueuesHelper.getValue(Queue.RANKED_SOLO_5X5), TiersHelper.getValue(Tier.CHALLENGER), DivisionsHelper.getValue(Division.I), fallbackAPI: true);
    challengerPlayers.addAll(that);
    challengerPlayersFiltered.addAll(that);
  }

  final matchItems = <MatchItem>[].obs;
  final highestWinRate = <MatchItem>[].obs;
  void getMostPlayedChampions(List<Match> myMatches) {

    var mapOfMostPlayedChampions = <String, int>{};
    for (var m in myMatches) {
      m.info?.participants?.forEach((p) async {
        if (mapOfMostPlayedChampions.containsKey(p.championName)) {

          final i = matchItems.indexWhere((element) => element.championName == p.championName);
          if(p.win == true) {
            matchItems[i].wins += 1;
          } else {
            matchItems[i].losses += 1;
          }
          //matchItems[i].damageDealtToChampions += p.totalDamageDealtToChampions??0;
          matchItems[i].damageDealtToChampions = "20";

          mapOfMostPlayedChampions.update(p.championName ?? "", (value) => value + 1);
        } else {
          matchItems.add(MatchItem(championName: "${p.championName}", wins: p.win == true ? 1 : 0, losses: p.win == false ? 1 : 0, imageUrl: urlHelper.buildChampionImage("${p.championName}.png")),);
          mapOfMostPlayedChampions.putIfAbsent(p.championName ?? "", () => 1);
        }
      });
    }
    matchItems.sort((a, b) {
      var bTotalGames = b.wins + b.losses;
      var aTotalGames = a.wins + a.losses;
      int? diff = bTotalGames.compareTo(aTotalGames);
      if (diff == 0) diff = aTotalGames.compareTo(bTotalGames);
      return diff;
    });

    //final filtered = highestWinRate.toSet().toList();
    highestWinRate.addAll(matchItems.where((p0) => p0.wins + p0.losses > 1).toList());
    highestWinRate.unique((x) => x.championName);
    highestWinRate.sort((a, b) {
      var bTotalGames = b.wins / (b.wins + b.losses);
      var aTotalGames = a.wins / (a.wins + a.losses);
      int? diff = bTotalGames.compareTo(aTotalGames);
      if (diff == 0) diff = aTotalGames.compareTo(bTotalGames);
      return diff;
    });
  }

  Future<String> getMatchesForRankedSummoner(int index) async {
    final rankedPlayer = challengerPlayers[index];
    final s = await getSummoner(false, rankedPlayer.summonerName??"", fallbackAPI: true);
    final matchHistories = await getMatchHistories(false, s?.puuid??"", fallbackAPI: true);
    final myMatches = <Match>[];
    final fiveMatches = <String>[];
    matchHistories?.take(5).forEach(fiveMatches.add);

    await Future.forEach(fiveMatches, (String element) async {
      await Future.delayed(const Duration(milliseconds: 500), () async {
        final m = await getMatch(element);
        myMatches.add(m?.match??Match());
        matches.add(m?.match??Match());
      });
    });

    final that = matches.toSet().toList();
    print("We should have ${that.length} matches vs ${matches.length}");

    final champs = await LeagueHelper().findMostPlayedChampions(s?.puuid??"", myMatches);
    final champ = champs.entries.first.key;
    final url = league.urlHelper.buildChampionImage("$champ.png");
    ///add all these matches to our main list of matches so we can calculate other stuff
    getMostPlayedChampions(myMatches);
    return url;
  }

  void filterChallengerPlayers(String text) {
    challengerPlayersFiltered.clear();
    challengerPlayersFiltered.addAll(challengerPlayers.where((p0) => p0.summonerName?.contains(text)==true).toList());
  }

  void pressedSearchButton() {
    showRankedSearchFilter.value = !showRankedSearchFilter.value;
  }

  void sortRankedPlayers() {
    if(sortByDropdownValue.value == SortByHelper.getValue(SortBy.LP)) {
      challengerPlayersFiltered.sort((a, b) {
        var diff = b.leaguePoints?.compareTo(a.leaguePoints??0);
        if (diff == 0) diff = a.leaguePoints?.compareTo(b.leaguePoints??0);
        return diff??0;
      });
    } else if (sortByDropdownValue.value == SortByHelper.getValue(SortBy.WINS)) {
      challengerPlayersFiltered.sort((a, b) {
        var diff = b.wins?.compareTo(a.wins??0);
        if (diff == 0) diff = a.wins?.compareTo(b.wins??0);
        return diff??0;
      });
    }else if (sortByDropdownValue.value == SortByHelper.getValue(SortBy.LOSSES)) {
      challengerPlayersFiltered.sort((a, b) {
          var diff = b.losses?.compareTo(a.losses??0);
          if (diff == 0) diff = a.losses?.compareTo(b.losses??0);
          return diff??0;
        });
    }else if (sortByDropdownValue.value == SortByHelper.getValue(SortBy.NAME)){
      challengerPlayersFiltered.sort((a, b) => a.summonerName?.toLowerCase().compareTo(b.summonerName??"".toLowerCase())??0);
    }else {
      challengerPlayersFiltered.sort((a, b) {
        var diff = b.leaguePoints?.compareTo(a.leaguePoints??0);
        if (diff == 0) diff = a.leaguePoints?.compareTo(b.leaguePoints??0);
        return diff??0;
      });
    }
  }

  //https://ddragon.leagueoflegends.com/cdn/12.4.1/img/champion/Aatrox.png
  Future<PaletteGenerator> updatePaletteGenerator(String image) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(Image.network(image).image,);
    return paletteGenerator;
  }
}
