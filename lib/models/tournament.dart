class GlobalTournament {
  final String tag;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final int maxLosses;

  GlobalTournament({
    required this.tag,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.maxLosses,
  });

  factory GlobalTournament.fromJson(Map<String, dynamic> json) {
    return GlobalTournament(
      tag: json['tag'],
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      maxLosses: json['maxLosses'] ?? 999,
    );
  }

  bool get isActive {
    final now = DateTime.now().toUtc();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  String get status => isActive ? "ACTIVO" : "Finalizado";
}