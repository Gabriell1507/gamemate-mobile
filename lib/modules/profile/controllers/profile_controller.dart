import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/modules/games/data/providers/games_provider.dart';
import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
import 'package:gamemate/modules/profile/data/models/user_profile_model.dart';
import 'package:gamemate/modules/profile/data/providers/profile_provider.dart';
import 'package:gamemate/utils/enums.dart';
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

  // Controle de loading geral
  RxBool isLoading = false.obs;

  // Dados do perfil e jogos sincronizados
  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxList<OwnedGameModel> syncedGames = <OwnedGameModel>[].obs;

  // Paginação e filtro dos jogos sincronizados
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final int pageSize = 20;
  final Rx<GameStatus?> filterStatus = Rx<GameStatus?>(null);
  final Rxn<Provider> filterProvider = Rxn<Provider>();


  final ApiService _apiService = ApiService();

  // Contas vinculadas
  Map<String, RxBool> linkedAccounts = {
    'Steam': false.obs,
  };

  final ProfileProvider profileProvider;
  String get backendUrl => dotenv.env['API_URL_DEV'] ?? '';

  ProfileController(this.profileProvider);

  // Toggle dropdown UI
  void toggleDropdown() => isDropdownOpen.value = !isDropdownOpen.value;

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

  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.getIdToken();
  }

  // Carrega perfil
  Future<void> loadUserProfile() async {
    final token = await getIdToken();
    if (token == null) return;

    try {
      isLoading(true);
      userProfile.value = await profileProvider.fetchUserProfile(token);
updateProfileFromModel(); // 🚩 garante atualização automática

// Atualiza contas vinculadas
if (userProfile.value != null) {
  for (var platform in linkedAccounts.keys) {
    linkedAccounts[platform]?.value = userProfile.value!.linkedAccounts
        .any((acc) => acc.provider.toLowerCase() == platform.toLowerCase());
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

  /// Carrega os jogos sincronizados, com paginação e filtro de status
  Future<void> loadSyncedGames({bool reset = false}) async {
    if (isLoadingMore.value) return;

    if (reset) {
      currentPage.value = 0; // Use skip/take, não page
      syncedGames.clear();
      hasMore.value = true;
    }
    if (!hasMore.value) return;

    isLoadingMore.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();
      if (idToken == null) throw Exception('Usuário não autenticado.');

      final gamesResponse = await _apiService.fetchUserOwnedGames(
        idToken: idToken,
        skip: currentPage.value * pageSize,
        take: pageSize,
        statusFilter: filterStatus.value?.name,
        providerFilter: filterProvider.value?.name,
      );

      syncedGames.addAll(gamesResponse.data);

      if (!gamesResponse.hasNextPage || gamesResponse.data.isEmpty) {
        hasMore.value = false;
      } else {
        currentPage.value += 1;
      }
    } catch (e) {
      Get.snackbar(
  'Erro',
  e.toString().replaceAll('Exception:', '').trim().isNotEmpty
      ? e.toString().replaceAll('Exception:', '').trim()
      : 'Ocorreu um erro inesperado. Tente novamente.',
);

    } finally {
      isLoadingMore.value = false;
    }
  }

  // Método para setar filtro e recarregar a lista
  void setFilter(GameStatus? status) {
    filterStatus.value = status;
    loadSyncedGames(reset: true);
  }
  
  void setProviderFilter(Provider? provider) {
  filterProvider.value = provider;
  loadSyncedGames(reset: true);
}


  // Abre link de autenticação Steam
  Future<void> openSteamLink() async {
    final token = await getIdToken();
    if (token == null) {
      print('Token não encontrado');
      return;
    }

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

  // Atualiza os valores do perfil reativo
  void updateProfileFromModel() {
    final profile = userProfile.value;
    if (profile == null) return;

    level.value = profile.level ?? '0';
    achievements.value = profile.achievements ?? 0;
    platinums.value = profile.platinums ?? 0;
    bio.value = profile.bio ?? '';
    avatarUrl.value = profile.avatarUrl?.isNotEmpty == true
        ? profile.avatarUrl!
        : "https://imgur.com/gallery/default-profile-image-JAvXY#jNNT4LE";

    games.value = profile.profileStats?.totalGames ?? 0;
    hoursPlayed.value = profile.profileStats?.totalHoursPlayed ?? 0;
    print("totalGames: ${profile.profileStats?.totalGames}, totalHoursPlayed: ${profile.profileStats?.totalHoursPlayed}");
  }

  // Inicializa o perfil e jogos ao iniciar
  Future<void> initializeProfileData() async {
    await loadUserProfile();
    updateProfileFromModel();
    await loadSyncedGames(reset: true);
  }

  @override
  void onInit() {
    super.onInit();
    initializeProfileData();
  }
}
