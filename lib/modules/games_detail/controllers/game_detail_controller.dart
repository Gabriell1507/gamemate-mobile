import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamemate/modules/games/data/models/games_detail_model.dart';
import 'package:gamemate/modules/games/data/providers/games_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = true.obs;
  final isAdding = false.obs; // para controlar loading do botão adicionar
  final gameDetails = Rxn<GameDetailsModel>();
  final isOwned = false.obs; // controla se usuário já possui o jogo

  late String uuid;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rawUuid = Get.arguments != null ? Get.arguments['uuid'] : null;
      uuid = rawUuid?.toString() ?? '';

      if (uuid.isEmpty) {
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
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();

      // Pega detalhes com token para saber se o usuário possui o jogo (isOwned)
      final details = await _apiService.getGameDetails(uuid, idToken: idToken);
      gameDetails.value = details;
      isOwned.value = details.isOwned; // assume que seu model tem essa propriedade
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar detalhes do jogo');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToLibrary() async {
    if (isAdding.value) return; // evita múltiplos cliques
    isAdding.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();

      if (idToken == null) {
        throw Exception('Usuário não autenticado.');
      }

      await _apiService.addGameToLibrary(uuid, idToken);

      // Atualiza localmente a flag para mudar a UI
      isOwned.value = true;

      Get.snackbar(
        'Sucesso',
        'Jogo adicionado à sua biblioteca!',
        backgroundColor: const Color(0xFF2284E6),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAdding.value = false;
    }
  }
}
