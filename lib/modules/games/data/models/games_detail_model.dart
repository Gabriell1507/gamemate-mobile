import 'package:gamemate/utils/enums.dart'; // seu enum GameStatus

class GameDetailsModel {
  final String id;
  final String name;
  final String? summary;
  final String? coverUrl;
  final double? rating;
  final DateTime? releaseDate;
  final List<String> genres;
  final List<String> platforms;
  final List<String> developers;
  final List<String> publishers;
  final List<String> screenshots; // ADICIONADO
  final bool isOwned;
  final int? playtimeMinutes;
  final DateTime? lastPlayedAt;
  final GameStatus? status;

  GameDetailsModel({
    required this.id,
    required this.name,
    this.summary,
    this.coverUrl,
    this.rating,
    this.releaseDate,
    this.genres = const [],
    this.platforms = const [],
    this.developers = const [],
    this.publishers = const [],
    this.screenshots = const [], // ADICIONADO
    this.isOwned = false,
    this.playtimeMinutes,
    this.lastPlayedAt,
    this.status,
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
      screenshots: json['screenshots'] != null ? List<String>.from(json['screenshots']) : [], // ADICIONADO
      isOwned: json['ownership'] != null ? json['ownership']['owned'] ?? false : false,
      playtimeMinutes: json['ownership'] != null ? json['ownership']['playtimeMinutes'] : null,
      lastPlayedAt: json['lastPlayedAt'] != null ? DateTime.tryParse(json['lastPlayedAt']) : null,
      status: json['status'] != null
          ? GameStatus.values.firstWhere(
              (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
              orElse: () => GameStatus.NUNCA_JOGADO,
            )
          : null,
    );
  }
}
