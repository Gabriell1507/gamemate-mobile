// library_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/utils/enums.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:gamemate/widgets/steam_game_card.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final ProfileController profileController = Get.find<ProfileController>();
  final RxString _searchQuery = ''.obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    profileController.loadSyncedGames(reset: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          profileController.hasMore.value &&
          !profileController.isLoadingMore.value) {
        profileController.loadSyncedGames();
      }
    });
  }

  List filteredGames() {
    final query = _searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return profileController.syncedGames;

    return profileController.syncedGames.where((game) {
      final name = game.name.toLowerCase();
      return name.contains(query);
    }).toList();
  }

GameStatus? stringToStatus(String? status) {
  switch (status) {
    case 'JOGANDO':
      return GameStatus.JOGANDO;
    case 'ZERADO':
      return GameStatus.ZERADO;
    case 'DROPADO':
      return GameStatus.DROPADO;
    case 'PLATINADO':
      return GameStatus.PLATINADO;
    case 'PROXIMO':
      return GameStatus.PROXIMO;
    case 'NUNCA_JOGADO':
      return GameStatus.NUNCA_JOGADO;
    default:
      return null;
  }
}



  Color? getBorderColor(GameStatus? status) {
  switch (status) {
    case GameStatus.JOGANDO:
      return const Color(0xFFD4AF37); // Dourado
    case GameStatus.ZERADO:
      return const Color(0xFF51FF00); // Verde
    case GameStatus.DROPADO:
      return const Color(0xFFF23030); // Vermelho
    case GameStatus.PLATINADO:
      return const Color(0xFF00FFFF); // Ciano
    case GameStatus.PROXIMO:
      return const Color.fromARGB(255, 215, 218, 12); // Azul
    case GameStatus.NUNCA_JOGADO:
    default:
      return null; // sem borda
  }
}


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Obx(() {
          if (profileController.syncedGames.isEmpty &&
              profileController.isLoadingMore.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                const SizedBox(height: 16),
                // Campo de busca
                TextField(
                  onChanged: (value) {
                    _searchQuery.value = value;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar jogo...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF0A2A52),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                // Dropdowns
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A2A52),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFF2284E6), width: 1),
                          ),
                          child: DropdownButton<GameStatus?>(
                            value: profileController.filterStatus.value,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0A2A52),
                            underline: const SizedBox(),
                            style: const TextStyle(color: Colors.white),
                            hint: const Text('Todos',
                                style: TextStyle(color: Colors.white),),
                            onChanged: (status) {
                              profileController.setFilter(status);
                              profileController.loadSyncedGames(reset: true);
                            },
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Todos',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              ...GameStatus.values.map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status.label,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A2A52),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFF2284E6), width: 1),
                          ),
                          child: DropdownButton<Provider?>(
                            value: profileController.filterProvider.value,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0A2A52),
                            underline: const SizedBox(),
                            style: const TextStyle(color: Colors.white),
                            hint: const Text('Todas as plataformas',
                                style: TextStyle(color: Colors.white)),
                            onChanged: (provider) {
                              profileController.setProviderFilter(provider);
                              profileController.loadSyncedGames(reset: true);
                            },
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Todas as plataformas',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              ...Provider.values.map(
                                (provider) => DropdownMenuItem(
                                  value: provider,
                                  child: Text(provider.name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Lista de jogos
                Expanded(
                  child: Obx(() {
                    final games = filteredGames();
                    if (games.isEmpty &&
                        !profileController.isLoadingMore.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/box.svg', height: 100),
                            const SizedBox(height: 12),
                            const Text('Nenhum jogo encontrado.',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      );
                    }

                    return Column(
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
                            Text('${games.length} Jogos',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Divider(
                                color: Color(0xFF2284E6),
                                thickness: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
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
                              final coverUrl = (game.coverUrl != null &&
                                      game.coverUrl!.startsWith('//'))
                                  ? 'https:${game.coverUrl}'
                                  : (game.coverUrl ?? '');

                              final gameStatus = stringToStatus(game.status);
                              final borderColor = getBorderColor(gameStatus);

                              return SteamGameCard(
                                name: game.name,
                                coverUrl: coverUrl,
                                borderColor: borderColor,
                                onTap: () {
                                  if (game.id.isEmpty) {
                                    Get.snackbar(
                                        'Erro', 'UUID do jogo não encontrado.');
                                    return;
                                  }
                                  Get.toNamed('/game-detail',
                                      arguments: {'uuid': game.id});
                                },
                              );
                            },
                          ),
                        ),
                        if (profileController.isLoadingMore.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
