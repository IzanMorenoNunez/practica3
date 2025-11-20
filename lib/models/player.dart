class ClashPlayer {
  final String tag;
  final String name;
  final int trophies;
  final int expLevel;
  final String arena;
  final int wins;
  final int losses;

  ClashPlayer({
    required this.tag,
    required this.name,
    required this.trophies,
    required this.expLevel,
    required this.arena,
    required this.wins,
    required this.losses,
  });

  factory ClashPlayer.fromJson(Map<String, dynamic> json) {
    final arena = json['arena']?['name'] ?? 'Desconocida';
    return ClashPlayer(
      tag: json['tag'],
      name: json['name'],
      trophies: json['trophies'],
      expLevel: json['expLevel'],
      arena: arena,
      wins: json['wins'],
      losses: json['losses'],
    );
  }
}