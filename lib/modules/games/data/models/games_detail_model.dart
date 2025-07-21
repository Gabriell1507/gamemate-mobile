import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
import 'package:gamemate/utils/enums.dart'; // seu enum GameStatus

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
  GameStatus? status;  // ADICIONE AQUI
  final List<String>? screenshots;

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
    this.status,  // ADICIONE NO CONSTRUTOR
    this.screenshots,
  });

  factory GameDetailsModel.fromOwnedGame(OwnedGameModel owned) {
    return GameDetailsModel(
      id: owned.id,
      name: owned.name,
      summary: owned.summary,
      coverUrl: owned.coverUrl,
      rating: owned.rating,
      releaseDate: owned.releaseDate != null ? DateTime.tryParse(owned.releaseDate!) : null,
      genres: owned.genres,
      platforms: owned.platforms,
      developers: owned.developers,
      publishers: owned.publishers,
      isOwned: true,
      playtimeMinutes: owned.playtimeMinutes,
      screenshots: const [], // ajuste se possuir
      status: GameStatus.values.firstWhere(
        (e) => e.name == owned.status,
        orElse: () => GameStatus.NUNCA_JOGADO, // ou o padrão desejado
      ),
    );
  }

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
      status: json['status'] != null
          ? GameStatus.values.firstWhere(
              (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
              orElse: () => GameStatus.NUNCA_JOGADO,
            )
          : null,
      screenshots: json['screenshots'] != null ? List<String>.from(json['screenshots']) : [],
    );
  }

  GameDetailsModel copyWith({
    String? id,
    String? name,
    String? summary,
    String? coverUrl,
    double? rating,
    DateTime? releaseDate,
    List<String>? genres,
    List<String>? platforms,
    List<String>? developers,
    List<String>? publishers,
    bool? isOwned,
    int? playtimeMinutes,
    DateTime? lastPlayedAt,
    GameStatus? status,
    List<String>? screenshots,
  }) {
    return GameDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      coverUrl: coverUrl ?? this.coverUrl,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      platforms: platforms ?? this.platforms,
      developers: developers ?? this.developers,
      publishers: publishers ?? this.publishers,
      isOwned: isOwned ?? this.isOwned,
      playtimeMinutes: playtimeMinutes ?? this.playtimeMinutes,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      status: status ?? this.status,
      screenshots: screenshots ?? this.screenshots,
    );
  }
}
