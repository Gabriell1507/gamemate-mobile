import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamemate/modules/stats/data/models/user_stats_model.dart';
import 'package:gamemate/modules/stats/data/service/user_stats_service.dart';
import 'package:get/get.dart';

class UserStatsController extends GetxController {
  final UserStatsService service;
  UserStatsController({required this.service});

  final isLoading = false.obs;
  final stats = Rxn<UserStats>();
  final error = ''.obs;

  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.getIdToken();
  }

  Future<void> fetchStats() async {
    if (_isFetching) return;

    _isFetching = true;
    isLoading.value = true;
    error.value = '';

    try {
      final token = await _getToken();
      if (token == null) {
        error.value = 'Usuário não autenticado.';
        return;
      }

      final result = await service.getUserStats(token);
      stats.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  /// Atualiza os dados manualmente (pull-to-refresh)
  Future<void> refresh() async => fetchStats();

  /// Soma de um campo específico entre todas as plataformas
  static int sumFromProviders(UserStats stats, String key) {
    int sum = 0;
    stats.byProvider.forEach((_, provider) {
      sum += provider.gamesByStatus[key] ?? 0;
    });
    return sum;
  }

  /// Soma total de horas entre todas as plataformas
  static double totalHours(UserStats stats) {
    double sum = 0;
    stats.byProvider.forEach((_, provider) {
      sum += provider.totalHoursPlayed;
    });
    return sum;
  }
}
