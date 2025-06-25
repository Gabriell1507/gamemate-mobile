import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:gamemate/widgets/steam_game_card.dart';
import 'package:gamemate/modules/games/controllers/games_controller.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final ProfileController profileController = Get.find<ProfileController>();
  final GamesController gamesController = Get.find<GamesController>();

  @override
  void initState() {
    super.initState();
    profileController.loadSyncedGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Biblioteca',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final games = profileController.syncedGames;

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            child: Divider(
                              color: Color(0xFF2284E6),
                              thickness: 3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${games.length} Jogos',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFF2284E6),
                              thickness: 3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (games.isEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/box.svg',
                              height: 100,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'OPS! Parece que você ainda não tem nenhum jogo adicionado.',
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      else
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: SteamGameCard.cardWidth /
                                  (SteamGameCard.imageHeight + 60),
                            ),
                            itemCount: games.length,
                            itemBuilder: (context, index) {
                              final game = games[index];
                              return SteamGameCard(
                                name: game.name,
                                coverUrl: game.coverUrl,
                                onTap: () async {
                                  try {
                                    await gamesController.searchGames(game.name);
                                    if (gamesController.searchResults.isNotEmpty) {
                                      Get.toNamed('/game-detail',
                                          arguments:
                                              gamesController.searchResults.first);
                                    }
                                  } catch (e) {
                                    print('Erro no onTap do card: $e');
                                  }
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
