import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/modules/games/data/models/games_detail_model.dart';
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
    final response = await _dio.get('/games/search', queryParameters: {'q': query});
    print('Resposta API searchGames: ${response.data}');
    final List data = response.data as List;
    return data.map((e) => IGDBGame.fromJson(e)).toList();
  } on DioException catch (dioError) {
    rethrow;
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

  Future<GameDetailsModel> getGameDetails(String uuid, {String? idToken}) async {
    try {
      final response = await _dio.get(
        '/games/$uuid',
        options: Options(
          headers: idToken != null ? {'Authorization': 'Bearer $idToken'} : null,
        ),
      );
      return GameDetailsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
