class MatchItem {
  final String championName;
  final String? imageUrl;
  final String? damageDealtToChampions;
  final int? gameDuration;
  final String? kda;
  final String? timeAgo;
  int? wins;
  int? losses;

  MatchItem({
    required this.championName,
    this.imageUrl,
    this.damageDealtToChampions,
    this.gameDuration,
    this.kda,
    this.timeAgo,
    this.wins,
    this.losses
  });
}