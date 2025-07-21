import 'package:flutter/material.dart';
import 'package:gamemate/utils/enums.dart';
import 'package:get/get.dart';
import '../controllers/game_detail_controller.dart';

class GameDetailsView extends GetView<GameDetailsController> {
  const GameDetailsView({super.key});

  // Helper para converter string do modelo para enum GameStatus
  GameStatus? _getCurrentStatus() {
    final statusString = controller.gameDetails.value?.status;
    if (statusString == null) return null;
    try {
      return GameStatus.values.firstWhere((e) => e.name == statusString);
    } catch (_) {
      return null;
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
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(4, 15, 26, 1),
              Color.fromRGBO(0, 31, 63, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final game = controller.gameDetails.value;
          if (game == null) {
            return const Center(
              child: Text('Erro ao carregar o jogo.', style: TextStyle(color: Colors.white)),
            );
          }

          final currentStatus = _getCurrentStatus();

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 16, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Capa do jogo
                if (game.coverUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        game.coverUrl!.startsWith('http') ? game.coverUrl! : 'https:${game.coverUrl!}',
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Dropdown para Provider (se não possuir o jogo)
                if (!controller.isOwned.value) 
                  Center(
                    child: Obx(() => DropdownButton<Provider>(
                      value: controller.selectedProvider.value,
                      dropdownColor: const Color.fromRGBO(0, 31, 63, 1),
                      style: const TextStyle(color: Colors.white),
                      items: Provider.values.map((provider) {
                        return DropdownMenuItem<Provider>(
                          value: provider,
                          child: Text(provider.name),
                        );
                      }).toList(),
                      onChanged: (provider) {
                        if (provider != null) controller.selectedProvider.value = provider;
                      },
                    )),
                  ),

                if (!controller.isOwned.value)
                  const SizedBox(height: 16),

                // Botões Adicionar / Remover da biblioteca
                Center(
                  child: Obx(() {
                    if (controller.isOwned.value) {
                      return ElevatedButton.icon(
                        onPressed: controller.isRemoving.value ? null : () => controller.removeFromLibrary(),
                        icon: controller.isRemoving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.delete_forever, color: Colors.white),
                        label: Text(
                          controller.isRemoving.value ? 'Removendo...' : 'Remover da Biblioteca',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      );
                    } else {
                      return ElevatedButton.icon(
                        onPressed: controller.isAdding.value ? null : () => controller.addToLibrary(),
                        icon: controller.isAdding.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.library_add, color: Colors.white),
                        label: Text(
                          controller.isAdding.value ? 'Adicionando...' : 'Adicionar à Biblioteca',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2284E6),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      );
                    }
                  }),
                ),

                const SizedBox(height: 20),

                // Nome e nota do jogo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        game.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (game.rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          game.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Dropdown para alterar status do jogo
                PopupMenuButton<GameStatus>(
                  tooltip: 'Alterar status',
                  icon: Icon(
                    Icons.flag,
                    color: currentStatus != null ? Colors.orange : Colors.white54,
                    size: 28,
                  ),
                  color: const Color(0xFF0A2A52),
                  onSelected: (status) {
                    if (status != null) {
                      controller.updateStatus(status);
                    }
                  },
                  itemBuilder: (context) {
                    return GameStatus.values.map((status) {
                      return CheckedPopupMenuItem<GameStatus>(
                        value: status,
                        checked: status == currentStatus,
                        child: Text(status.name, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList();
                  },
                ),

                // Datas, desenvolvedores e publicadoras
                if (game.releaseDate != null)
                  Text(
                    'Lançamento: ${game.releaseDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                if (game.developers != null && game.developers!.isNotEmpty)
                  Text('Desenvolvedor: ${game.developers!.join(', ')}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                if (game.publishers != null && game.publishers!.isNotEmpty)
                  Text('Publicadora: ${game.publishers!.join(', ')}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),

                const SizedBox(height: 16),

                // Gêneros
                if (game.genres != null && game.genres!.isNotEmpty) ...[
                  const Text(
                    'Gêneros:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.genres!
                        .map((g) => Chip(
                              label: Text(g),
                              backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 16),

                // Plataformas
                if (game.platforms != null && game.platforms!.isNotEmpty) ...[
                  const Text(
                    'Plataformas:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.platforms!
                        .map((p) => Chip(
                              label: Text(p),
                              backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),

                // Resumo
                if (game.summary != null) ...[
                  const Text(
                    'Resumo:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.summary!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ],

                const SizedBox(height: 24),

                // Capturas de tela
                if (game.screenshots != null && game.screenshots!.isNotEmpty) ...[
                  const Text(
                    'Capturas de tela:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: game.screenshots!.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final screenshotUrl = game.screenshots![index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            screenshotUrl.startsWith('http') ? screenshotUrl : 'https:$screenshotUrl',
                            width: 280,
                            height: 160,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(color: Colors.white));
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.black12,
                              width: 280,
                              height: 160,
                              child: const Icon(Icons.broken_image, color: Colors.white54),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
