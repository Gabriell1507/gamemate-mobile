import 'package:flutter/material.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:get/get.dart';


class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find();

  @override
Widget build(BuildContext context) {
  controller.loadUserProfile();
  controller.loadSyncedGames(); // ← carregar jogos sincronizados

  return Scaffold(
    appBar: AppBar(
      title: const Text('Perfil'),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    extendBodyBehindAppBar: true,
    body: Container(
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
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        final profile = controller.userProfile.value;
        if (profile == null) {
          return const Center(child: Text('Nenhum perfil carregado', style: TextStyle(color: Colors.white)));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${profile.email}', style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 10),
            Text('Nome: ${profile.name ?? 'Não informado'}', style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 20),

            const Text('Contas vinculadas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Expanded(
              child: ListView.builder(
                itemCount: profile.linkedAccounts.length,
                itemBuilder: (context, index) {
                  final acc = profile.linkedAccounts[index];
                  return ListTile(
                    tileColor: Colors.white10,
                    title: Text('${acc.provider} - ${acc.username ?? 'Sem nome'}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('ID: ${acc.providerAccountId}', style: const TextStyle(color: Colors.white70)),
                    trailing: acc.provider == 'STEAM'
                        ? IconButton(
                            icon: const Icon(Icons.link, color: Colors.redAccent),
                            onPressed: () async {
                              await controller.unlinkSteamAccount();
                              Get.snackbar('Sucesso', 'Conta Steam desvinculada',
                                  backgroundColor: Colors.green[700], colorText: Colors.white);
                            },
                          )
                        : null,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text('Jogos vinculados:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.syncedGames.isEmpty) {
                return const Text('Nenhum jogo sincronizado ainda.', style: TextStyle(color: Colors.white70));
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.syncedGames.length,
                  itemBuilder: (context, index) {
                    final game = controller.syncedGames[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: game.coverUrl != null
                                ? Image.network(game.coverUrl!, height: 140, width: 100, fit: BoxFit.cover)
                                : Container(
                                    height: 140,
                                    width: 100,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.videogame_asset, color: Colors.white54),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            game.name,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.openSteamLink(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 100, 200, 1),
                ),
                child: const Text('Ligar Conta Steam'),
              ),
            ),
          ],
        );
      }),
    ),
    bottomNavigationBar: const CustomBottomBar(),
  );
}
}