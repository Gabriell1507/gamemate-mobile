import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/modules/profile/data/models/owned_game_model.dart';
import 'package:gamemate/modules/profile/data/models/user_profile_model.dart';
import 'package:gamemate/modules/profile/data/providers/profile_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final ProfileProvider profileProvider;
   String get backendUrl => dotenv.env['API_URL_DEV'] ?? '';

  ProfileController(this.profileProvider);

  RxBool isLoading = false.obs;
  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  RxList<OwnedGameModel> syncedGames = RxList<OwnedGameModel>();
  

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