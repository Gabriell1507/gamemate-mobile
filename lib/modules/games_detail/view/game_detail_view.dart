import 'package:flutter/material.dart';
import 'package:gamemate/modules/games_detail/controllers/game_detail_controller.dart';
import 'package:get/get.dart';

class GameDetailView extends GetView<GameDetailController> {
  const GameDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = controller.game;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
              top: kToolbarHeight + 16, left: 16, right: 16, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Capa
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    game.coverImageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      game.totalRating.toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Data de lançamento
              Text(
  'Lançamento: ${controller.formatReleaseDate(game.firstReleaseDate)}',
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
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: game.genres
                      .map((g) => Chip(
                            label: Text(g.name),
                            backgroundColor: Color.fromRGBO(34, 132, 230, 1),
                            labelStyle: const TextStyle(color: Colors.white),
                          ))
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
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: game.platforms
                      .map((p) => Chip(
                            label: Text(p.abbreviation),
                            backgroundColor: Color.fromRGBO(34, 132, 230, 1),
                            labelStyle: const TextStyle(color: Colors.white),
                          ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 20),

              // Resumo
              const Text(
                'Resumo:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                    controller.translatedSummary.value.isNotEmpty
                        ? controller.translatedSummary.value
                        : game.summary,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.justify,
                  )),

              const SizedBox(height: 24),

              // Screenshots
              if (game.screenshots.isNotEmpty) ...[
                const Text(
                  'Capturas de tela:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: game.screenshots.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      final url = game.screenshots[index].url;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url,
                          width: 240,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
