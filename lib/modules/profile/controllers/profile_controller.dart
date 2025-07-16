import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
import 'package:gamemate/modules/profile/data/models/user_profile_model.dart';
import 'package:gamemate/modules/profile/data/providers/profile_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  // Dados básicos do perfil
  var level = '0'.obs;
  var games = 0.obs;
  var hoursPlayed = 0.obs;
  var achievements = 0.obs;
  var platinums = 0.obs;
  var bio = ''.obs;
  var avatarUrl = ''.obs;

  // Estado da UI
  var isDropdownOpen = false.obs;
  var confirmDelete = false.obs;

  // Controle de loading
  RxBool isLoading = false.obs;

  // Dados do perfil carregado e jogos sincronizados
  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  RxList<OwnedGameModel> syncedGames = RxList<OwnedGameModel>();

  // Contas vinculadas
  Map<String, RxBool> linkedAccounts = {
    'Steam': false.obs,
    // 'Epic': false.obs,
    // 'GOG': false.obs,
    // 'Ubisoft': false.obs,
    // 'EA': false.obs,
    // 'Amazon': false.obs,
    // 'Playstation': false.obs,
    // 'Xbox': false.obs,
    // 'Nintendo': false.obs,
  };

  final ProfileProvider profileProvider;
  String get backendUrl => dotenv.env['API_URL_DEV'] ?? '';

  ProfileController(this.profileProvider);

  // Abre ou fecha dropdown
  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  // Alterna vinculação de conta
  Future<void> toggleLink(String platform) async {
    if (isLoading.value) return;
    final current = linkedAccounts[platform];
    if (current == null) return;

    if (current.value) {
      try {
        isLoading(true);
        if (platform == 'Steam') {
          await unlinkSteamAccount();
          await loadUserProfile();
        }
      } catch (e) {
        print('Erro ao desvincular $platform: $e');
      } finally {
        isLoading(false);
      }
    } else {
      if (platform == 'Steam') {
        await openSteamLink();
      }
    }
  }

  // Obtém o ID token do usuário autenticado
  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.getIdToken();
  }

  // Carrega o perfil do usuário da API
  Future<void> loadUserProfile() async {
    final token = await getIdToken();
    if (token == null) return;

    try {
      isLoading(true);
      userProfile.value = await profileProvider.fetchUserProfile(token);

      // Atualiza contas vinculadas localmente
      if (userProfile.value != null) {
        for (var platform in linkedAccounts.keys) {
          linkedAccounts[platform]?.value =
              userProfile.value!.linkedAccounts.any((acc) =>
                  acc.provider.toLowerCase() == platform.toLowerCase());
        }
      }
    } finally {
      isLoading(false);
    }
  }

  // Remove conta Steam
  Future<void> unlinkSteamAccount() async {
    final token = await getIdToken();
    if (token == null) return;

    try {
      isLoading(true);
      await profileProvider.unlinkAccount('STEAM', token);
      await loadUserProfile();
    } finally {
      isLoading(false);
    }
  }

  // Carrega os jogos sincronizados
  Future<void> loadSyncedGames() async {
    final token = await getIdToken();
    if (token == null) return;

    try {
      isLoading(true);
      syncedGames.value = await profileProvider.fetchSyncedGames(token);
    } finally {
      isLoading(false);
    }
  }

  // Abre o link de autenticação Steam
  Future<void> openSteamLink() async {
    final token = await getIdToken();
    if (token == null) {
      print('Token não encontrado');
      return;
    }

    final backendUrl = dotenv.env['API_URL_DEV'] ?? '';
    final baseUrl = backendUrl.endsWith('/')
        ? backendUrl.substring(0, backendUrl.length - 1)
        : backendUrl;

    final tokenEncoded = Uri.encodeComponent(token);
    final Uri url = Uri.parse('$baseUrl/auth/steam?token=$tokenEncoded');

    print('Abrindo URL: $url');

    final canLaunch = await canLaunchUrl(url);
    if (!canLaunch) {
      throw Exception('Não foi possível abrir o link: $url');
    }

    final launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Falha ao lançar a URL: $url');
    }
  }

  // Atualiza os valores reativos com base no modelo
  void updateProfileFromModel() {
    final profile = userProfile.value;
    if (profile == null) return;

    level.value = profile.level ?? '0';
    achievements.value = profile.achievements ?? 0;
    platinums.value = profile.platinums ?? 0;
    bio.value = profile.bio ?? '';
    avatarUrl.value =
        profile.avatarUrl?.isNotEmpty == true ? profile.avatarUrl! : "https://i.imgur.com/4Zb1z5H.png";

    games.value = profile.profileStats?.totalGames ?? 0;
    hoursPlayed.value = profile.profileStats?.totalHoursPlayed ?? 0;
  }

  // Inicializa o perfil do usuário
  Future<void> initializeProfileData() async {
    await loadUserProfile();
    updateProfileFromModel();
    await loadSyncedGames(); // opcional
  }

  @override
  void onInit() {
    super.onInit();
    initializeProfileData();
  }
}
