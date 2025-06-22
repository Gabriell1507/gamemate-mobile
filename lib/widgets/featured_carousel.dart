import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamemate/modules/games/controllers/games_controller.dart';
import 'package:get/get.dart';
import 'package:gamemate/widgets/game_card.dart';

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
            final query = game.name;

            controller.isLoading.value = true;
            try {
              await controller.searchGames(query);
              controller.isLoading.value = false;

              if (controller.searchResults.isNotEmpty) {
                Get.toNamed('/game-detail',
                    arguments: controller.searchResults.first);
              }
            } catch (e) {
              controller.isLoading.value = false;
              print('Erro no onTap do carrossel: $e');
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
