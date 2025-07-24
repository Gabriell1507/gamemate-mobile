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
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...Provider.values.map((provider) {
              return ListTile(
                leading: const Icon(Icons.videogame_asset, color: Colors.white),
                title: Text(provider.name, style: const TextStyle(color: Colors.white)),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF040F1A), Color(0xFF001F3F)],
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

                Center(
                  child: Obx(() {
                    if (controller.isOwned.value) {
                      return ElevatedButton.icon(
                        onPressed: controller.isRemoving.value ? null : controller.removeFromLibrary,
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
                        onPressed: controller.isAdding.value ? null : () => _showProviderSelectionAndAdd(context),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        game.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerLeft,
                  child: PopupMenuButton<GameStatus>(
                    tooltip: 'Alterar status',
                    icon: Icon(
                      Icons.flag,
                      color: currentStatus != null ? Colors.orange : Colors.white70,
                      size: 28,
                    ),
                    color: const Color(0xFF0A2A52),
                    onSelected: (status) => controller.updateStatus(status),
                    itemBuilder: (context) {
                      return GameStatus.values.map((status) {
                        return CheckedPopupMenuItem<GameStatus>(
                          value: status,
                          checked: status == currentStatus,
                          child: Text(
                            status.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                if (game.releaseDate != null)
                  Text(
                    'Lançamento: ${game.releaseDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                if (game.developers != null && game.developers!.isNotEmpty)
                  Text(
                    'Desenvolvedor: ${game.developers!.join(', ')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                if (game.publishers != null && game.publishers!.isNotEmpty)
                  Text(
                    'Publicadora: ${game.publishers!.join(', ')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                const SizedBox(height: 16),

                if (game.genres != null && game.genres!.isNotEmpty) ...[
                  const Text(
                    'Gêneros:',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.genres!
                        .map((g) => Chip(
                              label: Text(g),
                              backgroundColor: const Color(0xFF2284E6),
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),

                if (game.platforms != null && game.platforms!.isNotEmpty) ...[
                  const Text(
                    'Plataformas:',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.platforms!
                        .map((p) => Chip(
                              label: Text(p),
                              backgroundColor: const Color(0xFF2284E6),
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),

                if (game.summary != null) ...[
                  const Text(
                    'Resumo:',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.summary!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }
}
