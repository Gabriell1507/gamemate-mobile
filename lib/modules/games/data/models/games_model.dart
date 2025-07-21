class IGDBImage {
  final String url;

  IGDBImage({required this.url});

  factory IGDBImage.fromJson(dynamic json) {
    if (json == null) return IGDBImage(url: '');
    if (json is String) {
      final rawUrl = json;
      final fullUrl = rawUrl.startsWith('//') ? 'https:$rawUrl' : rawUrl;
      return IGDBImage(url: fullUrl);
    }
    if (json is Map<String, dynamic>) {
      final rawUrl = json['url'] as String? ?? '';
      final fullUrl = rawUrl.startsWith('//') ? 'https:$rawUrl' : rawUrl;
      return IGDBImage(url: fullUrl);
    }
    return IGDBImage(url: '');
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

  IGDBGenre({required this.id, required this.name});

  factory IGDBGenre.fromJson(dynamic json) {
    if (json == null) return IGDBGenre(id: 0, name: '');
    if (json is Map<String, dynamic>) {
      int parseInt(dynamic value) {
        if (value == null) return 0;
        if (value is int) return value;
        if (value is String) return int.tryParse(value) ?? 0;
        return 0;
      }

      return IGDBGenre(
        id: parseInt(json['id']),
        name: json['name'] ?? '',
      );
    }
    return IGDBGenre(id: 0, name: '');
  }
}

class IGDBPlatform {
  final int id;
  final String abbreviation;

  IGDBPlatform({required this.id, required this.abbreviation});

  factory IGDBPlatform.fromJson(dynamic json) {
    if (json == null) return IGDBPlatform(id: 0, abbreviation: '');
    if (json is Map<String, dynamic>) {
      int parseInt(dynamic value) {
        if (value == null) return 0;
        if (value is int) return value;
        if (value is String) return int.tryParse(value) ?? 0;
        return 0;
      }

      return IGDBPlatform(
        id: parseInt(json['id']),
        abbreviation: json['abbreviation'] ?? '',
      );
    }
    return IGDBPlatform(id: 0, abbreviation: '');
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

  /// Usado para /games/featured
  factory IGDBGame.fromJson(Map<String, dynamic> json) {
    return IGDBGame(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      summary: json['summary'] ?? '',
      cover: IGDBImage.fromJson(json['cover']),
      firstReleaseDate: _parseInt(json['first_release_date']),
      totalRating: _parseDouble(json['total_rating']),
      developer: _parseCompanies(json['involved_companies'], 'developer'),
      publisher: _parseCompanies(json['involved_companies'], 'publisher'),
      genres: _parseGenres(json['genres']),
      platforms: _parsePlatforms(json['platforms']),
      screenshots: _parseImages(json['screenshots']),
    );
  }

  /// Usado para /games/search
  factory IGDBGame.fromSearchJson(Map<String, dynamic> json) {
    return IGDBGame(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      summary: json['summary'] ?? '',
      cover: IGDBImage.fromJson(json['coverUrl']), // vem como string
      firstReleaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'])?.millisecondsSinceEpoch ?? 0
          : 0,
      totalRating: _parseDouble(json['rating']),
      developer: _listToCommaString(json['developers']),
      publisher: _listToCommaString(json['publishers']),
      genres: _parseStringListToGenres(json['genres']),
      platforms: _parseStringListToPlatforms(json['platforms']),
      screenshots: _parseImages(json['screenshots']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static String _parseCompanies(dynamic companiesData, String key) {
    if (companiesData is List) {
      return companiesData
          .where((e) => e[key] == true && e['company'] != null)
          .map((e) => (e['company']?['name'] ?? '') as String)
          .join(', ');
    }
    return '';
  }

  static List<IGDBGenre> _parseGenres(dynamic genresData) {
    if (genresData is List) {
      return genresData.map((e) => IGDBGenre.fromJson(e)).toList();
    }
    return [];
  }

  static List<IGDBGenre> _parseStringListToGenres(dynamic genresData) {
    if (genresData is List) {
      return genresData
          .map((e) => IGDBGenre(id: 0, name: e.toString()))
          .toList();
    }
    return [];
  }

  static List<IGDBPlatform> _parsePlatforms(dynamic platformsData) {
    if (platformsData is List) {
      return platformsData.map((e) => IGDBPlatform.fromJson(e)).toList();
    }
    return [];
  }

  static List<IGDBPlatform> _parseStringListToPlatforms(dynamic platformsData) {
    if (platformsData is List) {
      return platformsData
          .map((e) => IGDBPlatform(id: 0, abbreviation: e.toString()))
          .toList();
    }
    return [];
  }

  static List<IGDBImage> _parseImages(dynamic imagesData) {
    if (imagesData is List) {
      return imagesData.map((e) => IGDBImage.fromJson(e)).toList();
    }
    return [];
  }

  static String _listToCommaString(dynamic listData) {
    if (listData is List && listData.isNotEmpty) {
      return listData.join(', ');
    }
    return '';
  }

  String get coverImageUrl {
    if (cover.url.isEmpty) return '';
    final id = cover.imageId;
    return 'https://images.igdb.com/igdb/image/upload/t_cover_big/$id.jpg';
  }
}
