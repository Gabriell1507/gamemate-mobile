class IGDBImage {
  final String url;

  IGDBImage({required this.url});

  factory IGDBImage.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['url'] as String? ?? '';
    final fullUrl = rawUrl.startsWith('//') ? 'https:$rawUrl' : rawUrl;
    return IGDBImage(url: fullUrl);
  }

  String get imageId {
    final parts = url.split('/');
    final filename = parts.isNotEmpty ? parts.last : '';
    return filename.split('.').first;
  }
}


class IGDBGenre {
  final int id;
  final String name;

  IGDBGenre({
    required this.id,
    required this.name,
  });

  factory IGDBGenre.fromJson(Map<String, dynamic> json) {
    return IGDBGenre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class IGDBPlatform {
  final int id;
  final String abbreviation;

  IGDBPlatform({
    required this.id,
    required this.abbreviation,
  });

  factory IGDBPlatform.fromJson(Map<String, dynamic> json) {
    return IGDBPlatform(
      id: json['id'] ?? 0,
      abbreviation: json['abbreviation'] ?? '',
    );
  }
}

class IGDBGame {
  final int id;
  final String name;
  final String summary;
  final IGDBImage cover;
  final int firstReleaseDate;
  final double totalRating;
  final String developer;
  final String publisher;
  final List<IGDBGenre> genres;
  final List<IGDBPlatform> platforms;
  final List<IGDBImage> screenshots;

  IGDBGame({
    required this.id,
    required this.name,
    required this.summary,
    required this.cover,
    required this.firstReleaseDate,
    required this.totalRating,
    required this.developer,
    required this.publisher,
    required this.genres,
    required this.platforms,
    required this.screenshots,
  });

  factory IGDBGame.fromJson(Map<String, dynamic> json) {
    return IGDBGame(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      summary: json['summary'] ?? '',
      cover: json['cover'] != null
          ? IGDBImage.fromJson(json['cover'])
          : IGDBImage(url: ''),
      firstReleaseDate: json['first_release_date'] ?? 0,
      totalRating: (json['total_rating'] != null)
          ? (json['total_rating'] as num).toDouble()
          : 0.0,
      genres: json['genres'] != null
          ? (json['genres'] as List)
              .map((e) => IGDBGenre.fromJson(e))
              .toList()
          : [],
      developer: json['developers'] != null && (json['developers'] as List).isNotEmpty
          ? (json['developers'] as List).map((e) => e['name'] as String).join(', ')
          : '',
      publisher: json['publishers'] != null && (json['publishers'] as List).isNotEmpty
          ? (json['publishers'] as List).map((e) => e['name'] as String).join(', ')
          : '',
      platforms: json['platforms'] != null
          ? (json['platforms'] as List)
              .map((e) => IGDBPlatform.fromJson(e))
              .toList()
          : [],
      screenshots: json['screenshots'] != null
          ? (json['screenshots'] as List)
              .map((e) => IGDBImage.fromJson(e))
              .toList()
          : [],
    );
  }
  String get coverImageUrl {
    if (cover.url.isEmpty) return '';

    final id = cover.imageId;
    return 'https://images.igdb.com/igdb/image/upload/t_cover_big/$id.jpg';
  }
}
