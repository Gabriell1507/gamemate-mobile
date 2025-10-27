import 'package:flutter/material.dart';
import 'package:gamemate/utils/enums.dart';
import 'package:get/get.dart';
import '../controllers/game_detail_controller.dart';

class GameDetailsView extends GetView<GameDetailsController> {
  const GameDetailsView({super.key});

  GameStatus? _getCurrentStatus() {
    final statusString = controller.gameDetails.value?.status;
    if (statusString == null) return null;
    try {
      return GameStatus.values.firstWhere((e) => e.name == statusString);
    } catch (_) {
      return null;
    }
  }



  void _showProviderSelectionAndAdd(BuildContext context) async {
    final selectedProvider = await showModalBottomSheet<Provider>(
      context: context,
      backgroundColor: const Color(0xFF0A2A52),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Selecione o provedor',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ...Provider.values.map((provider) {
              return ListTile(
                leading: const Icon(Icons.videogame_asset, color: Colors.white),
                title: Text(provider.name,
                    style: const TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: provider),
              );
            }).toList(),
            const SizedBox(height: 12),
          ],
        );
      },
    );

    if (selectedProvider != null) {
      controller.selectedProvider.value = selectedProvider;
      await controller.addToLibrary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF040F1A), Color(0xFF001F3F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          final game = controller.gameDetails.value;
          if (game == null) {
            return const Center(
              child: Text('Erro ao carregar o jogo.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final currentStatus = _getCurrentStatus();

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: kToolbarHeight + 16, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container principal
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF001F3F),
                    border: Border.all(
                      color: const Color(0xFF2284E6),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (game.coverUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            game.coverUrl!.startsWith('http')
                                ? game.coverUrl!
                                : 'https:${game.coverUrl!}',
                            height: 250,
                            width: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white));
                            },
                          ),
                        ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.name,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 12),

                            // Release Date
                            if (game.releaseDate != null)
                  Text(
                    'Lançamento: ${game.releaseDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                            // Rating
                            if (game.rating != null)
                              Text('Metacritic: ${game.rating!.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),

                            // Developers
                            if (game.developers != null &&
                                game.developers!.isNotEmpty)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Desenvolvedor: ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                    TextSpan(
                                      text: game.developers!.join(', '),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 34, 132, 230),
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),

                            // Publishers
                            if (game.publishers != null &&
                                game.publishers!.isNotEmpty)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Publicadora: ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                    TextSpan(
                                      text: game.publishers!.join(', '),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 34, 132, 230),
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Genres
                            if (game.genres != null && game.genres!.isNotEmpty) ...[
                              const Text(
                                'Gêneros:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: game.genres!.length,
                                  itemBuilder: (context, index) {
                                    final genre =
                                        game.genres![index % game.genres!.length];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Chip(
                                        label: Text(
                                          genre,
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                        backgroundColor: const Color(0xFF2284E6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        shape: const StadiumBorder(
                                          side: BorderSide(
                                              color: Colors.transparent, width: 0),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Plataformas horizontal
                if (game.platforms != null && game.platforms!.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Disponível: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: game.platforms!.map((platform) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(
                                  label: Text(
                                    platform,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  backgroundColor:
                                      const Color.fromRGBO(19, 73, 128, 1),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: const StadiumBorder(
                                      side: BorderSide(
                                          color: Colors.transparent, width: 0)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

// Possui o jogo? + Dropdown de status
// Coluna inteira
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Possui o jogo?
    Row(
      children: [
        const Text(
          'Possui o jogo? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 16),
        Obx(() {
          if (controller.isOwned.value) {
            return ElevatedButton(
              onPressed: controller.isRemoving.value ? null : controller.removeFromLibrary,
              child: Text(
                controller.isRemoving.value ? 'Removendo...' : 'Remover da Biblioteca',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            );
          } else {
            return ElevatedButton(
              onPressed: controller.isAdding.value ? null : () => _showProviderSelectionAndAdd(context),
              child: Text(
                controller.isAdding.value ? 'Adicionando...' : 'Adicionar à Biblioteca',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2284E6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            );
          }
        }),
      ],
    ),

    const SizedBox(height: 16),

    // Dropdown de status (aparece apenas se o jogo está na biblioteca)
    Obx(() {
      if (!controller.isOwned.value) return const SizedBox.shrink();

      final currentStatus = controller.gameDetails.value?.status ?? GameStatus.NUNCA_JOGADO;

      return Row(
        children: [
          const Text(
            'Status: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2A52),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromRGBO(34, 132, 230, 1), width: 1),
              ),
              child: DropdownButton<GameStatus>(
                value: currentStatus,
                dropdownColor: const Color(0xFF0A2A52),
                underline: const SizedBox(),
                isExpanded: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (status) {
                  if (status != null) {
                    controller.updateStatus(status); // atualiza o estado e backend
                  }
                },
                items: GameStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.label, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    }),
  ],
),
// Nova Box: Screenshots + Sumário
if ((game.screenshots != null && game.screenshots!.isNotEmpty) || (game.summary != null && game.summary!.isNotEmpty))
  Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(0, 31, 63, 1), // fundo
      border: Border.all(color: const Color.fromRGBO(34, 132, 230, 1), width: 1), // borda azul
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carrossel de screenshots
        if (game.screenshots != null && game.screenshots!.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: game.screenshots!.length,
              itemBuilder: (context, index) {
                final screenshot = game.screenshots![index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      screenshot.startsWith('http') ? screenshot : 'https:$screenshot',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                            child: CircularProgressIndicator(color: Colors.white));
                      },
                    ),
                  ),
                );
              },
            ),
          ),

        if (game.summary != null && game.summary!.isNotEmpty) ...[
          const SizedBox(height: 16),
          
          const SizedBox(height: 8),
          Text(
            game.summary!,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ],
    ),
  ),


                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}