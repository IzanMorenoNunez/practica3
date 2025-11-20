class ClashCard {
  final String name;
  final int id;
  final int elixirCost;
  final String rarity;
  final String mediumIcon;
  final String? evolutionIcon;

  ClashCard({
    required this.name,
    required this.id,
    required this.elixirCost,
    required this.rarity,
    required this.mediumIcon,
    this.evolutionIcon,
  });

  factory ClashCard.fromJson(Map<String, dynamic> json) {
    final iconUrls = json['iconUrls'] as Map<String, dynamic>;
    return ClashCard(
      name: json['name'],
      id: json['id'],
      elixirCost: json['elixirCost'] ?? 0,
      rarity: json['rarity'] ?? 'common',
      mediumIcon: iconUrls['medium'] ?? '',
      evolutionIcon: iconUrls['evolutionMedium'],
    );
  }
}