import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_detail_controller.dart';

class GameDetailsView extends GetView<GameDetailsController> {
  const GameDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Jogo'),
        backgroundColor: const Color(0xFF001F3F),
      ),
      backgroundColor: const Color(0xFF001F3F),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        final game = controller.gameDetails.value;
        if (game == null) {
          return const Center(
            child: Text('Erro ao carregar o jogo.', style: TextStyle(color: Colors.white)),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (game.coverUrl != null)
                Center(
                  child: Image.network(
                    game.coverUrl!.startsWith('http') ? game.coverUrl! : 'https:${game.coverUrl!}',
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                game.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (game.summary != null) ...[
                const SizedBox(height: 8),
                Text(game.summary!, style: const TextStyle(color: Colors.white70)),
              ],
              const SizedBox(height: 8),
              if (game.rating != null)
                Text('⭐ Nota: ${game.rating!.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white)),
              if (game.releaseDate != null)
                Text('📅 Lançamento: ${game.releaseDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.white)),
              if (game.genres != null && game.genres!.isNotEmpty)
                Text('🎮 Gêneros: ${game.genres!.join(', ')}', style: const TextStyle(color: Colors.white)),
              if (game.platforms != null && game.platforms!.isNotEmpty)
                Text('🖥️ Plataformas: ${game.platforms!.join(', ')}', style: const TextStyle(color: Colors.white)),
              if (game.developers != null && game.developers!.isNotEmpty)
                Text('🛠️ Desenvolvedores: ${game.developers!.join(', ')}', style: const TextStyle(color: Colors.white)),
              if (game.publishers != null && game.publishers!.isNotEmpty)
                Text('📦 Publicadoras: ${game.publishers!.join(', ')}', style: const TextStyle(color: Colors.white)),

              const SizedBox(height: 20),

              // Botão condicional
              Obx(() {
                if (controller.isOwned.value) {
                  return Chip(
                    label: Text(
                      'Na Biblioteca',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  );
                } else {
                  return ElevatedButton(
                    onPressed: controller.isAdding.value ? null : () => controller.addToLibrary(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2284E6),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: controller.isAdding.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Adicionar à Biblioteca'),
                  );
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
