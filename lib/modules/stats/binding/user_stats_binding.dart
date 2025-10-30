import 'package:get/get.dart';
import 'package:gamemate/modules/stats/controller/user_stats_controller.dart';
import 'package:gamemate/modules/stats/data/service/user_stats_service.dart';

class UserStatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserStatsService>(() => UserStatsService(), fenix: true);
    Get.lazyPut<UserStatsController>(() => UserStatsController(service: Get.find()), fenix: true);
  }
}
