import 'package:get/get.dart';
import '../data/models/games_model.dart';
import '../data/providers/games_provider.dart';

class GamesController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<IGDBGame> games = <IGDBGame>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getFeaturedGames();
  }

  Future<void> searchGames(String query) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _apiService.searchGames(query);
      games.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Erro ao buscar jogos.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getFeaturedGames() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _apiService.getFeaturedGames();
      games.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Erro ao buscar jogos em destaque.';
    } finally {
      isLoading.value = false;
    }
  }
}
