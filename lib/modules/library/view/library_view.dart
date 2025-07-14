import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:gamemate/widgets/steam_game_card.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final ProfileController profileController = Get.find<ProfileController>();

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
                                  (SteamGameCard.imageHeight + 90),
                            ),
                            itemCount: games.length,
                            itemBuilder: (context, index) {
                              final game = games[index];
                              // Ajusta coverUrl para URL completa se começar com //
                              final coverUrl = (game.coverUrl != null && game.coverUrl!.startsWith('//'))
                                  ? 'https:${game.coverUrl}'
                                  : (game.coverUrl ?? '');

                              return SteamGameCard(
                                name: game.name,
                                coverUrl: coverUrl,
                                onTap: () {
                                  if (game.id.isEmpty) {
                                    Get.snackbar('Erro', 'UUID do jogo não encontrado.');
                                    return;
                                  }
                                  Get.toNamed('/game-detail', arguments: {'uuid': game.id});
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
