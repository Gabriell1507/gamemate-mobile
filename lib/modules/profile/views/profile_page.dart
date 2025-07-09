import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find();
  final AuthService authService = Get.find<AuthService>();

  final Map<String, String> platformAssets = {
    'Steam': 'assets/platforms/steam.svg',
    'Epic': 'assets/platforms/epic.svg',
    'GOG': 'assets/platforms/gog.svg',
    'Ubisoft': 'assets/platforms/ubisoft.svg',
    'EA': 'assets/platforms/ea.svg',
    'Amazon': 'assets/platforms/amazon.svg',
    'Playstation': 'assets/platforms/playstation.svg',
    'Xbox': 'assets/platforms/xbox.svg',
    'Nintendo': 'assets/platforms/nintendo.svg',
  };

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadUserProfile();
    controller.loadSyncedGames();

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const CustomBottomBar(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Perfil Principal ---
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white12,
                        child: Icon(Icons.person, size: 32, color: Colors.white70),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name ?? 'Nome não informado',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level: ${controller.level.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                controller.bio.value.isNotEmpty
                                    ? controller.bio.value
                                    : '...',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Estatísticas ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Estatísticas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBox('Jogos', controller.games),
                    _buildStatBox('Horas jogadas', controller.hoursPlayed),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBox('Conquistas', controller.achievements),
                    _buildStatBox('Platinados', controller.platinums),
                  ],
                ),

                const SizedBox(height: 24),

                // --- Botão Editar Perfil ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar ação de editar perfil
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Editar perfil',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- Dropdown Vinculação ---
                GestureDetector(
                  onTap: controller.toggleDropdown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Vinculação',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          controller.isDropdownOpen.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                if (controller.isDropdownOpen.value) ...[
                  const SizedBox(height: 12),
                  ...controller.linkedAccounts.entries.map((entry) {
                    final platform = entry.key;
                    final isLinked = entry.value.value;

                    return Card(
                      color: Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: SvgPicture.asset(
                          platformAssets[platform] ?? '',
                          width: 32,
                          height: 32,
                        ),
                        title: Text(
                          platform,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => controller.toggleLink(platform),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLinked
                                ? Colors.green
                                : const Color.fromRGBO(34, 132, 230, 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isLinked ? 'Vinculado' : 'Vincular',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],

                const SizedBox(height: 24),

               

                const SizedBox(height: 24),

                // --- Seção Excluir Conta ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Excluir minha conta',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Todos os seus dados serão apagados do sistema.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.confirmDelete.value,
                                onChanged: (val) =>
                                    controller.confirmDelete.value = val ?? false,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Color.fromRGBO(34, 132, 230, 1);
                                  }
                                  return Colors.white;
                                }),
                                checkColor: Colors.white,
                              )),
                          const Text('Tenho certeza',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.confirmDelete.value
                                  ? () async {
                                      await controller.unlinkSteamAccount();
                                      await authService.deleteAccount();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                disabledBackgroundColor: Colors.red.withOpacity(0.5),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Excluir',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatBox(String label, RxInt value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Obx(() => Text(
                  '${value.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
