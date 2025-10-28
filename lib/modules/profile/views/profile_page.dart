import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.find();
  final AuthService authService = Get.find<AuthService>();

  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(
      text: controller.userProfile.value?.name ?? '',
    );

    Get.defaultDialog(
      title: 'Editar Nome',
      backgroundColor: const Color(0xFF001F3F),
      titleStyle: const TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Novo nome',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.length < 3) {
                  Get.snackbar(
                      'Erro', 'O nome deve ter pelo menos 3 caracteres.');
                  return;
                }
                Get.back();
                await controller.updateUserName(newName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
              ),
              child:
                  const Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF001F3F),
        ),
        child: const CustomBottomBar(),
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
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final profile = controller.userProfile.value;

            if (profile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nenhum perfil carregado',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => controller.initializeProfileData(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Tentar recarregar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => await controller.initializeProfileData(),
              color: Colors.white,
              backgroundColor: const Color(0xFF001F3F),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Perfil Principal ---
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001F3F),
                        border: Border.all(
                          color: const Color.fromRGBO(34, 132, 230, 1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await controller.uploadProfilePhoto();
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Obx(() => Container(
                                          width: 170,
                                          height: 170,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF001F3F),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  34, 132, 230, 1),
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: controller
                                                    .avatarUrl.value.isNotEmpty
                                                ? Image.network(
                                                    controller.avatarUrl.value,
                                                    width: 170,
                                                    height: 170,
                                                    fit: BoxFit.cover,
                                                  )
                                                : const Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Color.fromRGBO(
                                                          34, 132, 230, 1),
                                                      size: 80,
                                                    ),
                                                  ),
                                          ),
                                        )),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              34, 132, 230, 1),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.name ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Estatísticas',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatBox('Jogos', controller.games),
                              _buildStatBox(
                                  'Horas jogadas', controller.hoursPlayed),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Botão Editar Perfil ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showEditNameDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(34, 132, 230, 1),
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Botão do Dropdown ---
                        GestureDetector(
                          onTap: controller.toggleDropdown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF001F3F),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF2284E6), width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Vinculação',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Obx(
                                  () => Icon(
                                    controller.isDropdownOpen.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // --- Conteúdo Animado do Dropdown ---
                        Obx(
                          () => AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: controller.isDropdownOpen.value
                                ? Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF001F3F),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFF2284E6),
                                          width: 1),
                                    ),
                                    child: Column(
                                      children: controller
                                          .linkedAccounts.entries
                                          .map((entry) {
                                        final platform = entry.key;
                                        final isLinked = entry.value.value;

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              // Ícone + nome da plataforma
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    platformAssets[platform] ??
                                                        '',
                                                    width: 32,
                                                    height: 32,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    platform,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const Spacer(),

                                              // Botão de reload
                                              IconButton(
                                                onPressed: () => controller
                                                    .reloadSteamAccount(),
                                                icon: const Icon(
                                                  Icons.sync,
                                                  color: Color(0xFF2284E6),
                                                ),
                                              ),

                                              // Botão de vincular / desvincular
                                              ElevatedButton(
                                                onPressed: () => controller
                                                    .toggleLink(platform),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isLinked
                                                      ? Colors.green
                                                      : const Color(0xFF2284E6),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  isLinked
                                                      ? 'Vinculado'
                                                      : 'Vincular',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- Seção Excluir Conta ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001F3F),
                        border: Border.all(
                          color: const Color.fromRGBO(34, 132, 230, 1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Excluir minha conta',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Todos os seus dados serão apagados do sistema.',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: controller.confirmDelete.value,
                                  onChanged: (val) => controller
                                      .confirmDelete.value = val ?? false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                      color: Color(0xFF2284E6),
                                      width: 2), // borda azul
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return const Color.fromRGBO(
                                          34, 132, 230, 1);
                                    }
                                    return const Color(
                                        0xFF001F3F); // fundo quando não selecionado
                                  }),
                                  checkColor: Colors.white,
                                ),
                              ),
                              const Text('Tenho certeza',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.confirmDelete.value
                                    ? () async {
                                        await authService.deleteAccount();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  disabledBackgroundColor:
                                      Colors.red.withOpacity(0.5),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Excluir',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 54),

                    // --- Botão Sair ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await authService.signOut();
                          Get.offAllNamed('/login');
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Sair',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2284E6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, RxInt value) {
    return Container(
      width: 140,
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF040F1A),
        border: Border.all(
          color: const Color(0xFF2284E6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 34, 132, 230),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                value.value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }
}
