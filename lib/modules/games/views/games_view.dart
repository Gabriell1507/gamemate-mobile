import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamemate/widgets/game_card.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gamemate/modules/games/data/models/games_model.dart';
import '../controllers/games_controller.dart';

class GamesView extends StatefulWidget {
  const GamesView({super.key});

  @override
  State<GamesView> createState() => _GamesViewState();
}

class _GamesViewState extends State<GamesView> {
  final GamesController _controller = Get.find<GamesController>();

  static const double _carouselItemWidth = 150;
  static const double _carouselItemHeight = 220;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/gamemate_login_logo.svg', height: 46),
                const SizedBox(height: 16),

                // Seção: Especiais da semana com dois divisores
                const Row(
                  children:  [
                    SizedBox(
                      width: 20,
                      child: Divider(
                        color: Color(0xFF2284E6),
                        thickness: 3,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Especiais da semana',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: Color(0xFF2284E6),
                        thickness: 3,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _buildSpecialsCarousel(),

                const SizedBox(height: 20),

                // Seção: Seus jogos
                const Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Divider(
                        color: Color(0xFF2284E6),
                        thickness: 3,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Seus jogos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: Color(0xFF2284E6),
                        thickness: 3,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/gamepad.svg',
                          height: 50,
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Adicione alguns jogos vinculando suas contas no perfil ou pesquisando individualmente!",
                            style: TextStyle(
                              color: Color.fromRGBO(34, 132, 230, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

Widget _buildSpecialsCarousel() {
  return CarouselSlider.builder(
    itemCount: _controller.games.length,
    itemBuilder: (context, index, realIndex) {
      final game = _controller.games[index];

      return Container(
        width: _carouselItemWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: GameCard(game: game),
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