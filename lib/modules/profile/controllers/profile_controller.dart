import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
import 'package:gamemate/modules/profile/data/models/user_profile_model.dart';
import 'package:gamemate/modules/profile/data/providers/profile_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  // Dados básicos do perfil

  var level = '22'.obs;
  var games = 126.obs;
  var hoursPlayed = 20.obs;
  var achievements = 880.obs;
  var platinums = 13.obs;
  var bio = 'Lorem ipsum dolor sit amet. Sed veniam tempora in quia incidunt aut facere quia.'.obs;
  var avatarUrl = "https://i.imgur.com/4Zb1z5H.png".obs;

  // Estado da UI
  var isDropdownOpen = false.obs;
  var confirmDelete = false.obs;

  // Controle de loading
  RxBool isLoading = false.obs;

  // Dados do perfil carregado e jogos sincronizados
  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  RxList<OwnedGameModel> syncedGames = RxList<OwnedGameModel>();

  // Contas vinculadas, controle local do toggle
  Map<String, RxBool> linkedAccounts = {
    'Steam': false.obs,
    'Epic': false.obs,
    'GOG': false.obs,
    'Ubisoft': false.obs,
    'EA': false.obs,
    'Amazon': false.obs,
    'Playstation': false.obs,
    'Xbox': false.obs,
    'Nintendo': false.obs,
  };

  final ProfileProvider profileProvider;
  String get backendUrl => dotenv.env['API_URL_DEV'] ?? '';

  ProfileController(this.profileProvider);

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  Future<void> toggleLink(String platform) async {
    if (isLoading.value) return;
    final current = linkedAccounts[platform];
    if (current == null) return;

    if (current.value) {
      // Se já vinculado, desvincular
      try {
        isLoading(true);
        if (platform == 'Steam') {
          await unlinkSteamAccount();
          await loadUserProfile(); // Atualiza perfil e linkedAccounts
        }
      } catch (e) {
        print('Erro ao desvincular $platform: $e');
      } finally {
        isLoading(false);
      }
    } else {
      // Se não vinculado, abrir link OAuth
      if (platform == 'Steam') {
        await openSteamLink();
        // Atualizará perfil após retorno do OAuth
      }
    }
  }

  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<void> loadUserProfile() async {
    final token = await getIdToken();
    if (token == null) return;

    try {
      isLoading(true);
      userProfile.value = await profileProvider.fetchUserProfile(token);

      // Atualiza linkedAccounts baseado no perfil
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

  


}
