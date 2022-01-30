import 'package:dart_lol/LeagueStuff/match.dart';

class MatchesSeenChampion {
  final String championName;
  final String championId;
  List<Match> matches;

  MatchesSeenChampion({
    required this.championName,
    required this.championId,
    required this.matches
  });
}