



import 'package:example_nav2/services/globals.dart';

// void getSummonerData() async {
//   await Future.delayed(const Duration(seconds: 2), () async {
//     final s = await league.getSummonerFromAPI(false, "Doublelift", fallbackAPI: true);
//     print(s);
//     if (s != null) {
//       final histories = await getMatchHistories(false, s.puuid??"", fallbackAPI: true);
//       var list = <Match>[];
//       final ten = histories?.take(10);
//       await Future.forEach(ten!, (String element) async {
//         final m = await getMatch(element);
//         print("got match ${m?.match?.info?.gameId}");
//         list.add(m?.match??Match());
//         Future.delayed(Duration(milliseconds: 500));
//       });
//       print("should have ${list.length} matches");
//       final that = await LeagueHelper().findMostPlayedChampions(s.puuid??"", list);
//       print("champion played: ${that.entries.first.key}");
//     }
//   });
// }
