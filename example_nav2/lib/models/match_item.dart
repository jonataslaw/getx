class MatchItem {
  final String championName;
  String? imageUrl;
  String? damageDealtToChampions;
  int gameDuration;
  String? kda;
  String? timeAgo;
  int wins;
  int losses;

  MatchItem({
    required this.championName,
    this.imageUrl,
    this.damageDealtToChampions = "",
    this.gameDuration = 0,
    this.kda = "",
    this.timeAgo = "",
    this.wins = 0,
    this.losses = 0
  });
}