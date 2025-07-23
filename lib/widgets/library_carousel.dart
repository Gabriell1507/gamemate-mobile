import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gamemate/widgets/steam_game_card.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'dart:math';

class LibraryCarousel extends StatelessWidget {
  final ProfileController controller;

  const LibraryCarousel({super.key, required this.controller});

  static const double _carouselItemWidth = 150;

  @override
  Widget build(BuildContext context) {
    final allGames = controller.syncedGames.toList();

    if (allGames.isEmpty && !controller.isLoadingMore.value) {
      return const Column(
        children:  [
          SizedBox(height: 12),
          Text(
            'Nenhum jogo encontrado.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      );
    }

    // Embaralha e pega 9
    allGames.shuffle(Random());
    final games = allGames.take(9).toList();

    return CarouselSlider.builder(
      itemCount: games.length,
      itemBuilder: (context, index, realIndex) {
        final game = games[index];
        final coverUrl = (game.coverUrl != null && game.coverUrl!.startsWith('//'))
            ? 'https:${game.coverUrl}'
            : (game.coverUrl ?? '');

        return GestureDetector(
          onTap: () async {
            try {
              if (game.id.isEmpty) {
                Get.snackbar('Erro', 'UUID do jogo não encontrado.');
                return;
              }
      
              final uuid = game.id;

              if (uuid.isNotEmpty) {
                Get.toNamed('/game-detail', arguments: {'uuid': uuid});
              } else {
                Get.snackbar('Erro', 'UUID não encontrado para o jogo.');
              }
            } catch (e) {
              print('Erro ao abrir detalhes do jogo: $e');
              Get.snackbar('Erro', 'Não foi possível abrir os detalhes do jogo.');
            }
          },
          child: Container(
            width: _carouselItemWidth,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: SteamGameCard(
              name: game.name,
              coverUrl: coverUrl,
              onTap: () {}, 
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 310,
        enlargeCenterPage: false,
        viewportFraction: 0.5,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.linear,
      ),
    );
  }
}
