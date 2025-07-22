import 'package:flutter/material.dart';
import 'package:gamemate/modules/games/controllers/search_games_result_controller.dart';
import 'package:gamemate/modules/games/data/providers/games_provider.dart';
import 'package:get/get.dart';
import '../../../widgets/game_card.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SearchResultsView extends GetView<SearchResultsController> {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
              'Resultados para "${controller.query.value}"',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Obx(() {
          final results = controller.searchResults;

          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/gamepad.svg',
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Nenhum jogo encontrado.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha com divisores e texto centralizado
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
                    '${results.length} resultado(s) encontrado(s)',
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

              // Grid dos resultados - ocupa espaço restante da tela
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final game = results[index];
                    return GestureDetector(
                      onTap: () async {
                        try {
                          controller.isLoading.value = true;
                          final uuid = await ApiService()
                              .resolveGameId(igdbId: game.id.toString());
                          controller.isLoading.value = false;

                          if (uuid.isNotEmpty) {
                            Get.toNamed('/game-detail', arguments: {'uuid': uuid});
                          } else {
                            Get.snackbar(
                                'Erro', 'UUID não encontrado para o jogo.');
                          }
                        } catch (e) {
                          controller.isLoading.value = false;
                          Get.snackbar(
                              'Erro', 'Não foi possível abrir os detalhes do jogo.');
                        }
                      },
                      child: GameCard(game: game),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
