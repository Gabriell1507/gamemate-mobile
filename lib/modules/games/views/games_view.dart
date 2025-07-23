import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:gamemate/widgets/featured_carousel.dart';
import 'package:get/get.dart';
import '../controllers/games_controller.dart';
import 'package:gamemate/widgets/library_carousel.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';

class GamesView extends StatefulWidget {
  const GamesView({super.key});

  @override
  State<GamesView> createState() => _GamesViewState();
}

class _GamesViewState extends State<GamesView> {
  final GamesController _controller = Get.find<GamesController>();
  final TextEditingController _searchController = TextEditingController();
  final ProfileController _profileController = Get.find<ProfileController>();

  Future<void> _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) return;

    _controller.isLoading.value = true;
    await _controller.searchGames(query.trim());
    _controller.isLoading.value = false;

    if (_controller.searchResults.isEmpty) {
      Get.snackbar(
        'Nenhum resultado',
        'Nenhum jogo encontrado para "$query"',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      Get.toNamed('/result-page', arguments: {
        'results': _controller.searchResults.toList(),
        'query': query.trim(),
      });
    }

    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/gamemate_login_logo.svg', height: 46),
                  const SizedBox(height: 16),

                  // === BARRA DE BUSCA ===
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Pesquisar jogos...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                    onSubmitted: _onSearchSubmitted,
                  ),

                  const SizedBox(height: 16),

                  // === ESPECIAIS DA SEMANA ===
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

                  FeaturedCarousel(controller: _controller),

                  const SizedBox(height: 20),

                  // === SEUS JOGOS ===
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

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 330, // Altura fixa para o carousel dos jogos
                    child: Obx(() {
                      final games = _profileController.syncedGames;
                      if (games.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/gamepad.svg',
                                  height: 50,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF2284E6),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Adicione alguns jogos vinculando suas contas no perfil ou pesquisando individualmente!",
                                  style: TextStyle(
                                    color: Color(0xFF2284E6),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return LibraryCarousel(controller: _profileController);
                      }
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
