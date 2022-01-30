


import 'package:dart_lol/LeagueStuff/champions.dart';
import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/ddragon_storage.dart';
import 'package:example_nav2/models/matches_seen_champion.dart';
import 'package:example_nav2/services/globals.dart';

class MatchesHelper {

  DDragonStorage dDragonStorage = league.dDragonStorage;

  List<MatchesSeenChampion> findMostSeenChampion(List<Match> matches) {
    final returnList = <MatchesSeenChampion>[];
    matches.forEach((m) {
      m.info?.participants?.forEach((p) {
        final championId = p.championId;

        var myListFiltered = returnList.where((e) => e.championId == championId);
        if (myListFiltered.length > 0) {
          final that = myListFiltered.first;
          that.matches.add(m);
        } else {
          //final matchesSeenChampion = MatchesSeenChampion(championName: championName, championId: championId, matches: matches)
          // Element is not found
        }
      });
    });
    return returnList;
  }

  Future<Datum?> returnChampionFromId(int championId) async {
    final championsDb = await dDragonStorage.getChampionsFromDb();
    return championsDb.data?.entries.firstWhere((element) => element.value.key == "${championId}").value;
  }
}