import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';

class PaginatedGamesResponse {
  final List<OwnedGameModel> data;
  final int total;
  final bool hasNextPage;

  PaginatedGamesResponse({
    required this.data,
    required this.total,
    required this.hasNextPage,
  });

  factory PaginatedGamesResponse.fromMap(Map<String, dynamic> map) {
    return PaginatedGamesResponse(
      data: (map['data'] as List<dynamic>)
          .map((json) => OwnedGameModel.fromMap(json))
          .toList(),
      total: map['total'] ?? 0,
      hasNextPage: map['hasNextPage'] ?? false,
    );
  }
}
