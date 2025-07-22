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
        child: Padding(
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

              // Dropdown de filtro de status
              Obx(() {
                return DropdownButton<GameStatus?>(
                  value: profileController.filterStatus.value,
                  dropdownColor: const Color(0xFF0A2A52),
                  style: const TextStyle(color: Colors.white),
                  hint: const Text('Filtrar por status', style: TextStyle(color: Colors.white)),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todos'),
                    ),
                    ...GameStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      ),
                    )
                  ],
                  onChanged: (status) {
                    profileController.setFilter(status);
                    profileController.loadSyncedGames(reset: true);
                  },
                );
              }),
              Obx(() {
  return DropdownButton<Provider?>(
    value: profileController.filterProvider.value,
    dropdownColor: const Color(0xFF0A2A52),
    style: const TextStyle(color: Colors.white),
    hint: const Text('Filtrar por plataforma', style: TextStyle(color: Colors.white)),
    items: [
      const DropdownMenuItem(
        value: null,
        child: Text('Todas as plataformas'),
      ),
      ...Provider.values.map(
        (provider) => DropdownMenuItem(
          value: provider,
          child: Text(provider.name),
        ),
      )
    ],
    onChanged: (provider) {
      profileController.setProviderFilter(provider);
      profileController.loadSyncedGames(reset: true);
    },
  );
}),

              const SizedBox(height: 16),

              Expanded(
                child: Obx(() {
                  final games = filteredGames();

                  if (games.isEmpty && !profileController.isLoadingMore.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/box.svg', height: 100),
                          const SizedBox(height: 12),
                          const Text(
                            'Nenhum jogo encontrado.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // === INSERINDO O SEU TRECHO AQUI ===
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

                      const SizedBox(height: 12),

                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: SteamGameCard.cardWidth /
                                (SteamGameCard.imageHeight + 90),
                          ),
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            final game = games[index];
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
                      if (profileController.hasMore.value)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Obx(() => ElevatedButton(
                                onPressed: profileController.isLoadingMore.value
                                    ? null
                                    : () => profileController.loadSyncedGames(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2284E6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                ),
                                child: profileController.isLoadingMore.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text(
                                        'Carregar mais',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              )),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
