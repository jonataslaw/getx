class MatchItem {
  final String championName;
  final String imageUrl;
  final String damageDealtToChampions;
  final int gameDuration;
  final String kda;
  final String timeAgo;

  MatchItem({
    required this.championName,
    required this.imageUrl,
    required this.damageDealtToChampions,
    required this.gameDuration,
    required this.kda,
    required this.timeAgo
  });
}