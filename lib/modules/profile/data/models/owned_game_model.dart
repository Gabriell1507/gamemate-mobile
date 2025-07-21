class OwnedGameModel {
  final String id;
  final String? steamAppId;
  final String? igdbId;
  final String name;
  final String? summary;
  final String? coverUrl;
  final String? releaseDate; // ISO 8601
  final double? rating;
  final List<String> genres;
  final List<String> developers;
  final List<String> publishers;
  final List<String> platforms;
  final int? playtimeMinutes;
  final String status;
  final String sourceProvider;

  OwnedGameModel({
    required this.id,
    this.steamAppId,
    this.igdbId,
    required this.name,
    this.summary,
    this.coverUrl,
    this.releaseDate,
    this.rating,
    required this.genres,
    required this.developers,
    required this.publishers,
    required this.platforms,
    this.playtimeMinutes,
    required this.status,
    required this.sourceProvider,
  });

  factory OwnedGameModel.fromMap(Map<String, dynamic> map) {
    return OwnedGameModel(
      id: map['id'] ?? '',
      steamAppId: map['steamAppId'],
      igdbId: map['igdbId'],
      name: map['name'] ?? '',
      summary: map['summary'],
      coverUrl: map['coverUrl'],
      releaseDate: map['releaseDate'],
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      genres: List<String>.from(map['genres'] ?? []),
      developers: List<String>.from(map['developers'] ?? []),
      publishers: List<String>.from(map['publishers'] ?? []),
      platforms: List<String>.from(map['platforms'] ?? []),
      playtimeMinutes: map['playtimeMinutes'],
      status: map['status'] ?? 'NUNCA_JOGADO',
      sourceProvider: map['sourceProvider'] ?? 'GAMEMATE',
    );
  }
}
