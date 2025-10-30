class UserStats {
  final OverallStats overall;
  final Map<String, ProviderStats> byProvider;

  UserStats({
    required this.overall,
    required this.byProvider,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      overall: OverallStats.fromJson(json['overall']),
      byProvider: (json['byProvider'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, ProviderStats.fromJson(value)),
      ),
    );
  }
}

class OverallStats {
  final int totalGames;
  final int totalPlaytimeMinutes;
  final double totalHoursPlayed;

  OverallStats({
    required this.totalGames,
    required this.totalPlaytimeMinutes,
    required this.totalHoursPlayed,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalGames: json['totalGames'],
      totalPlaytimeMinutes: json['totalPlaytimeMinutes'],
      totalHoursPlayed: (json['totalHoursPlayed'] as num).toDouble(),
    );
  }
}

class ProviderStats {
  final int totalGames;
  final int totalPlaytimeMinutes;
  final double totalHoursPlayed;
  final Map<String, int> gamesByStatus;
  final List<GameGenre> genres;

  ProviderStats({
    required this.totalGames,
    required this.totalPlaytimeMinutes,
    required this.totalHoursPlayed,
    required this.gamesByStatus,
    required this.genres,
  });

  factory ProviderStats.fromJson(Map<String, dynamic> json) {
    return ProviderStats(
      totalGames: json['totalGames'],
      totalPlaytimeMinutes: json['totalPlaytimeMinutes'],
      totalHoursPlayed: (json['totalHoursPlayed'] as num).toDouble(),
      gamesByStatus: Map<String, int>.from(json['gamesByStatus']),
      genres: (json['genres'] as List)
          .map((e) => GameGenre.fromJson(e))
          .toList(),
    );
  }
}

class GameGenre {
  final String name;
  final int count;

  GameGenre({
    required this.name,
    required this.count,
  });

  factory GameGenre.fromJson(Map<String, dynamic> json) {
    return GameGenre(
      name: json['name'],
      count: json['count'],
    );
  }
}
