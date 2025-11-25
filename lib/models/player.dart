class ClashPlayer {
  final String tag;
  final String name;
  final int trophies;
  final int expLevel;
  final String arena;
  final int wins;
  final int losses;
  final int kingTowerLevel;
  final List<CurrentDeckCard> currentDeck;
  final Clan? clan;

  ClashPlayer({
    required this.tag,
    required this.name,
    required this.trophies,
    required this.expLevel,
    required this.arena,
    required this.wins,
    required this.losses,
    required this.kingTowerLevel,
    required this.currentDeck,
    this.clan,
  });

  factory ClashPlayer.fromJson(Map<String, dynamic> json) {
    final List<dynamic> cardsJson = json['currentDeck'] ?? [];
    final currentDeck = cardsJson.map((c) => CurrentDeckCard.fromJson(c)).toList();

    final clanJson = json['clan'] as Map<String, dynamic>?;
    final clan = clanJson != null ? Clan.fromJson(clanJson) : null;

    return ClashPlayer(
      tag: json['tag'],
      name: json['name'],
      trophies: json['trophies'] ?? 0,
      expLevel: json['expLevel'] ?? 0,
      arena: json['arena']?['name'] ?? 'Desconocida',
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      kingTowerLevel: json['kingTowerLevel'] ?? 1,
      currentDeck: currentDeck,
      clan: clan,
    );
  }
}

class CurrentDeckCard {
  final String name;
  final int level;
  final int elixirCost;
  final String iconUrl;

  CurrentDeckCard({
    required this.name,
    required this.level,
    required this.elixirCost,
    required this.iconUrl,
  });

  factory CurrentDeckCard.fromJson(Map<String, dynamic> json) {
    return CurrentDeckCard(
      name: json['name'],
      level: json['level'],
      elixirCost: json['elixirCost'] ?? 0,
      iconUrl: json['iconUrls']?['medium'] ?? '',
    );
  }
}

class Clan {
  final String tag;
  final String name;
  final int badgeId;

  Clan({required this.tag, required this.name, required this.badgeId});

  factory Clan.fromJson(Map<String, dynamic> json) {
    return Clan(
      tag: json['tag'],
      name: json['name'],
      badgeId: json['badgeId'],
    );
  }
}