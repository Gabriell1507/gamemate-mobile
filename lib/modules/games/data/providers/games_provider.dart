import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      final List data = response.data as List;
      return data.map((e) => IGDBGame.fromJson(e)).toList();
    } on DioException catch (dioError) {
      print('DioError status: ${dioError.response?.statusCode}');
      print('DioError data: ${dioError.response?.data}');
      print('DioError message: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }

  Future<List<IGDBGame>> getFeaturedGames() async {
    try {
      final response = await _dio.get('/games/featured');
      final List data = response.data as List;
      return data.map((e) => IGDBGame.fromJson(e)).toList();
    } on DioException catch (dioError) {
      print('DioError status: ${dioError.response?.statusCode}');
      print('DioError data: ${dioError.response?.data}');
      print('DioError message: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }
}
