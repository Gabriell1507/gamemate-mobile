import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamemate/modules/games/data/models/games_detail_model.dart';
import 'package:gamemate/modules/games/data/providers/games_provider.dart';
import 'package:gamemate/utils/enums.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class GameDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = true.obs;
  final isAdding = false.obs;
  final isUpdatingStatus = false.obs;
  final isRemoving = false.obs;

  final gameDetails = Rxn<GameDetailsModel>();
  final isOwned = false.obs;
  final selectedProvider = Provider.GAMEMATE.obs;
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

      final details = await _apiService.getGameDetails(uuid, idToken: idToken);
      gameDetails.value = details;
      isOwned.value = details.isOwned;
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar detalhes do jogo');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToLibrary() async {
  if (isAdding.value) return;
  isAdding.value = true;

  try {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) throw Exception('Usuário não autenticado.');

    await _apiService.addGameToLibraryWithProvider(uuid, idToken, selectedProvider.value);

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


Future<void> updateStatus(GameStatus newStatus) async {
  if (isUpdatingStatus.value) return;
  isUpdatingStatus.value = true;

  try {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();
    if (idToken == null) throw Exception('Usuário não autenticado.');

    // Atualiza no backend
    await _apiService.updateGameStatus(uuid, newStatus.name, idToken);

    // Atualiza localmente o gameDetails com o enum diretamente
    gameDetails.value = gameDetails.value?.copyWith(status: newStatus);
    gameDetails.refresh();

    isOwned.value = true; // mantém coerência

    Get.snackbar(
      'Sucesso',
      'Status do jogo atualizado para ${newStatus.name}.',
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
    isUpdatingStatus.value = false;
  }
}


  Future<void> removeFromLibrary() async {
    if (isRemoving.value) return;
    isRemoving.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();
      if (idToken == null) throw Exception('Usuário não autenticado.');

      await _apiService.removeGameFromLibrary(uuid, idToken);

      isOwned.value = false;

      Get.snackbar(
        'Sucesso',
        'Jogo removido da sua biblioteca.',
        backgroundColor: const Color(0xFF2284E6),
        colorText: Colors.white,
      );

      // Opcional: fecha a tela após remover
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRemoving.value = false;
    }
  }
}