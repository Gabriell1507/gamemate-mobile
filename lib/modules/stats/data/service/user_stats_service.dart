import 'package:dio/dio.dart';
import '../models/user_stats_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserStatsService {
  final Dio _dio;

  UserStatsService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: dotenv.env['API_URL_DEV'] ?? '',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                responseType: ResponseType.json,
              ),
            )..interceptors.add(LogInterceptor(
                requestBody: false,
                responseBody: false, // evita travar o app com logs longos
              ));

  Future<UserStats> getUserStats(String token) async {
    try {
      final response = await _dio.get(
        '/users/me/stats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserStats.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Erro desconhecido';
      throw Exception('Erro ao carregar estatísticas: $msg');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
