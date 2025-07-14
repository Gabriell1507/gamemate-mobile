import 'package:flutter/widgets.dart';
import 'package:gamemate/modules/games/data/models/games_detail_model.dart';
import 'package:gamemate/modules/games/data/providers/games_provider.dart';
import 'package:get/get.dart';

class GameDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = true.obs;
  final gameDetails = Rxn<GameDetailsModel>();

@override
void onInit() {
  super.onInit();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final rawUuid = Get.arguments != null ? Get.arguments['uuid'] : null;
    final uuid = rawUuid?.toString();

    if (uuid == null || uuid.isEmpty) {
      Get.snackbar('Erro', 'UUID não fornecido.');
      Get.back();
      return;
    }

    await fetchGameDetails(uuid);
  });
}


  Future<void> fetchGameDetails(String uuid) async {
    try {
      isLoading.value = true;
      final details = await _apiService.getGameDetails(uuid);
      gameDetails.value = details;
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar detalhes do jogo');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }
}
