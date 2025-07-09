  import 'package:dio/dio.dart';
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
  import 'package:gamemate/modules/profile/data/models/user_profile_model.dart';

  class ProfileProvider {
    final Dio _dio;

    ProfileProvider(Dio find, {Dio? dio})
        : _dio = dio ??
              Dio(
                BaseOptions(
                  baseUrl: dotenv.env['API_URL_DEV'] ?? '',
                  connectTimeout: const Duration(seconds: 15),
                  receiveTimeout: const Duration(seconds: 15),
                ),
              )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    Future<UserProfileModel?> fetchUserProfile(String token) async {
    try {
      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserProfileModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Usuário não encontrado, retorna null
        return null;
      }
      // Repassa outras exceções para serem tratadas em outro nível
      rethrow;
    }
  }


    Future<void> unlinkAccount(String provider, String token) async {
      await _dio.delete(
        '/users/me/linked-accounts/$provider',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    }

    Future<List<OwnedGameModel>> fetchSyncedGames(String token) async {
      final response = await _dio.get(
        '/users/me/games',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return (response.data as List)
          .map((json) => OwnedGameModel.fromMap(json))
          .toList();
    }
  }
