import 'package:flutter/material.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.loadUserProfile();
    controller.loadSyncedGames();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF040F1A),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 32, 16, 16),
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

          final profile = controller.userProfile.value;
          if (profile == null) {
            return const Center(
              child: Text(
                'Nenhum perfil carregado',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(profile),
              const SizedBox(height: 4),
              const Text(
                'Contas vinculadas',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: profile.linkedAccounts.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma conta vinculada',
                          style: TextStyle(color: Colors.white38),
                        ),
                      )
                    : ListView.separated(
                        itemCount: profile.linkedAccounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final acc = profile.linkedAccounts[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${acc.provider} - ${acc.username ?? 'Sem nome'}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'ID: ${acc.providerAccountId}',
                                style: const TextStyle(color: Colors.white60, fontSize: 13),
                              ),
                              trailing: acc.provider == 'STEAM'
                                  ? IconButton(
                                      icon: const Icon(Icons.link_off_rounded, color: Colors.redAccent),
                                      onPressed: () async {
                                        await controller.unlinkSteamAccount();
                                        Get.snackbar(
                                          'Sucesso',
                                          'Conta Steam desvinculada',
                                          backgroundColor: Colors.green[700],
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.openSteamLink(),
                  icon: const Icon(Icons.link, color: Colors.white),
                  label: const Text(
                    'Ligar Conta Steam',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0064C8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildInfoCard(profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white12,
            child: Icon(Icons.person, size: 32, color: Colors.white70),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? 'Nome não informado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
