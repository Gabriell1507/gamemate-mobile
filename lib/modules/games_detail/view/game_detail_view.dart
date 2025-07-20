import 'package:flutter/material.dart';
import 'package:gamemate/utils/enums.dart';
import 'package:get/get.dart';
import '../controllers/game_detail_controller.dart';

class GameDetailsView extends GetView<GameDetailsController> {
  const GameDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(4, 15, 26, 1),
              Color.fromRGBO(0, 31, 63, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final game = controller.gameDetails.value;
          if (game == null) {
            return const Center(
              child: Text('Erro ao carregar o jogo.', style: TextStyle(color: Colors.white)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 16,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Capa
                if (game.coverUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        game.coverUrl!.startsWith('http')
                            ? game.coverUrl!
                            : 'https:${game.coverUrl!}',
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Nome e nota
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        game.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (game.rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          game.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Datas, desenvolvedor, publicadora
                if (game.releaseDate != null)
                  Text(
                    'Lançamento: ${game.releaseDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                if (game.developers.isNotEmpty)
                  Text(
                    'Desenvolvedor: ${game.developers.join(', ')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                if (game.publishers.isNotEmpty)
                  Text(
                    'Publicadora: ${game.publishers.join(', ')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                const SizedBox(height: 16),

                // Gêneros
                if (game.genres.isNotEmpty) ...[
                  const Text(
                    'Gêneros:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.genres
                        .map(
                          (g) => Chip(
                            label: Text(g),
                            backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 16),

                // Plataformas
                if (game.platforms.isNotEmpty) ...[
                  const Text(
                    'Plataformas:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.platforms
                        .map(
                          (p) => Chip(
                            label: Text(p),
                            backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),

                // Resumo
                if (game.summary != null) ...[
                  const Text(
                    'Resumo:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.summary!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ],

                const SizedBox(height: 24),

                // Screenshots
                if (game.screenshots.isNotEmpty) ...[
                  const Text(
                    'Capturas de tela:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: game.screenshots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        final url = game.screenshots[index].startsWith('http')
                            ? game.screenshots[index]
                            : 'https:${game.screenshots[index]}';
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            url,
                            width: 240,
                            height: 160,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
