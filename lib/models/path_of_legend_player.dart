class PathOfLegendPlayer {
  final String tag;
  final String name;
  final int expLevel;
  final int eloRating;
  final int rank;
  final String? clanName;
  final String? clanTag;
  final int? clanBadgeId;

  PathOfLegendPlayer({
    required this.tag,
    required this.name,
    required this.expLevel,
    required this.eloRating,
    required this.rank,
    this.clanName,
    this.clanTag,
    this.clanBadgeId,
  });

  factory PathOfLegendPlayer.fromJson(Map<String, dynamic> json) {
    final clan = json['clan'] as Map<String, dynamic>?;
    return PathOfLegendPlayer(
      tag: json['tag'],
      name: json['name'],
      expLevel: json['expLevel'],
      eloRating: json['eloRating'],
      rank: json['rank'],
      clanName: clan?['name'],
      clanTag: clan?['tag'],
      clanBadgeId: clan?['badgeId'],
    );
  }
}