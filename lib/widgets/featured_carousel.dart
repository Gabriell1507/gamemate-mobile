import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamemate/modules/games/data/providers/games_provider.dart';
import 'package:get/get.dart';
import 'package:gamemate/widgets/game_card.dart';
import 'package:gamemate/modules/games/controllers/games_controller.dart';

class FeaturedCarousel extends StatelessWidget {
  final GamesController controller;

  const FeaturedCarousel({super.key, required this.controller});

  static const double _carouselItemWidth = 150;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: controller.featuredGames.length,
      itemBuilder: (context, index, realIndex) {
        final game = controller.featuredGames[index];

        return GestureDetector(
          onTap: () async {
  controller.isLoading.value = true;
  try {
    final uuid = await ApiService().resolveGameId(igdbId: game.id.toString());
    controller.isLoading.value = false;

    if (uuid.isNotEmpty) {
      Get.toNamed('/game-detail', arguments: {'uuid': uuid});
    } else {
      Get.snackbar('Erro', 'UUID não encontrado para o jogo.');
    }
  } catch (e) {
    controller.isLoading.value = false;
    print('Erro no onTap do carrossel: $e');
    Get.snackbar('Erro', 'Não foi possível abrir os detalhes do jogo.');
  }
},

          child: Container(
            width: _carouselItemWidth,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: GameCard(game: game),
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
