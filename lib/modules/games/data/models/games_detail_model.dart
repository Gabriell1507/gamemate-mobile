class GameDetailsModel {
  final String id;
  final String name;
  final String? summary;
  final String? coverUrl;
  final double? rating;
  final DateTime? releaseDate;
  final List<String>? genres;
  final List<String>? platforms;
  final List<String>? developers;
  final List<String>? publishers;
  final bool isOwned;
  final int? playtimeMinutes;
  final DateTime? lastPlayedAt;

  GameDetailsModel({
    required this.id,
    required this.name,
    this.summary,
    this.coverUrl,
    this.rating,
    this.releaseDate,
    this.genres,
    this.platforms,
    this.developers,
    this.publishers,
    this.isOwned = false,
    this.playtimeMinutes,
    this.lastPlayedAt,
  });

  factory GameDetailsModel.fromJson(Map<String, dynamic> json) {
    return GameDetailsModel(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      coverUrl: json['coverUrl'],
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : null,
      releaseDate: json['releaseDate'] != null ? DateTime.tryParse(json['releaseDate']) : null,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
      platforms: json['platforms'] != null ? List<String>.from(json['platforms']) : [],
      developers: json['developers'] != null ? List<String>.from(json['developers']) : [],
      publishers: json['publishers'] != null ? List<String>.from(json['publishers']) : [],
      isOwned: json['isOwned'] ?? false,
      playtimeMinutes: json['playtimeMinutes'],
      lastPlayedAt: json['lastPlayedAt'] != null ? DateTime.tryParse(json['lastPlayedAt']) : null,
    );
  }
}
