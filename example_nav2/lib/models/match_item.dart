class MatchItem {
  final String championName;
  String? imageUrl;
  int damageDealtToChampions;
  int gameDuration;
  int kda;
  int timeAgo;
  int wins;
  int losses;

  MatchItem({
    required this.championName,
    this.imageUrl,
    this.damageDealtToChampions = 0,
    this.gameDuration = 0,
    this.kda = 0,
    this.timeAgo = 0,
    this.wins = 0,
    this.losses = 0
  });
}