import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/modules/games/data/models/games_detail_model.dart';
import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
import 'package:gamemate/utils/enums.dart';
import '../models/games_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL_DEV'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  Future<List<IGDBGame>> searchGames(String query) async {
    try {
      final response =
          await _dio.get('/games/search', queryParameters: {'q': query});
      print('Resposta API searchGames: ${response.data}');
      final List data = response.data as List;
      return data.map((e) => IGDBGame.fromJson(e)).toList();
    } on DioException catch (dioError) {
      rethrow;
    }
  }

Future<void> addGameToLibraryWithProvider(String gameId, String idToken, Provider provider) async {
  try {
    final response = await _dio.post(
      '/users/me/games',
      data: {
        'gameId': gameId,
        'sourceProvider': provider.name, // usa a extensão para pegar o nome string
      },
      options: Options(
        headers: {'Authorization': 'Bearer $idToken'},
      ),
    );

    if (response.statusCode != 201) {
      final error = response.data['message'] ?? 'Falha ao adicionar o jogo.';
      throw Exception(error);
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final message = e.response?.data['message'] ?? 'Erro na requisição.';
      throw Exception(message);
    } else {
      throw Exception('Erro de conexão.');
    }
  }
}



  Future<List<IGDBGame>> getFeaturedGames() async {
    try {
      final response = await _dio.get('/games/featured');
      final List data = response.data as List;
      return data.map((e) => IGDBGame.fromJson(e)).toList();
    } on DioException catch (dioError) {
      rethrow;
    }
  }

  Future<String> resolveGameId({String? igdbId, String? steamAppId}) async {
    try {
      final response = await _dio.get('/games/resolve', queryParameters: {
        if (igdbId != null) 'igdbId': igdbId,
        if (steamAppId != null) 'steamAppId': steamAppId,
      });
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  Future<GameDetailsModel> getGameDetails(String uuid,
      {String? idToken}) async {
    try {
      final response = await _dio.get(
        '/games/$uuid',
        options: Options(
          headers:
              idToken != null ? {'Authorization': 'Bearer $idToken'} : null,
        ),
      );
      return GameDetailsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OwnedGameModel>> fetchUserOwnedGames(String idToken) async {
  try {
    final response = await _dio.get(
      '/users/me/games',
      options: Options(
        headers: {'Authorization': 'Bearer $idToken'},
      ),
    );

    final List data = response.data as List;
    return data.map((e) => OwnedGameModel.fromMap(e)).toList();
  } on DioException catch (e) {
    if (e.response != null) {
      final message = e.response?.data['message'] ?? 'Erro ao buscar jogos.';
      throw Exception(message);
    } else {
      throw Exception('Erro de conexão.');
    }
  }
}

Future<OwnedGameModel> updateGameStatus(
    String gameId, String status, String idToken) async {
  try {
    final response = await _dio.put(
      '/users/me/games/$gameId/status',
      data: {'status': status},
      options: Options(
        headers: {'Authorization': 'Bearer $idToken'},
      ),
    );

    return OwnedGameModel.fromMap(response.data);
  } on DioException catch (e) {
    if (e.response != null) {
      final message = e.response?.data['message'] ?? 'Erro ao atualizar status.';
      throw Exception(message);
    } else {
      throw Exception('Erro de conexão.');
    }
  }
}

Future<void> removeGameFromLibrary(String gameId, String idToken) async {
  try {
    final response = await _dio.delete(
      '/users/me/games',
      data: {'gameId': gameId},
      options: Options(
        headers: {'Authorization': 'Bearer $idToken'},
      ),
    );

    if (response.statusCode != 204) {
      final error = response.data['message'] ?? 'Falha ao remover o jogo.';
      throw Exception(error);
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final message = e.response?.data['message'] ?? 'Erro na requisição.';
      throw Exception(message);
    } else {
      throw Exception('Erro de conexão.');
    }
  }
}


}
